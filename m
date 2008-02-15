Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbYBOKy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbYBOKy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbYBOKyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:54:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:58989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893AbYBOKyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:54:51 -0500
To: "Dan Gora" <dan.gora@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI Bursting with PIO
From: Andi Kleen <andi@firstfloor.org>
References: <4779de450802141928led16cebkfb989551eb88a8cb@mail.gmail.com>
Date: Fri, 15 Feb 2008 11:54:50 +0100
In-Reply-To: <4779de450802141928led16cebkfb989551eb88a8cb@mail.gmail.com> (Dan Gora's message of "Thu\, 14 Feb 2008 19\:28\:55 -0800")
Message-ID: <p73abm21ocl.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Dan Gora" <dan.gora@gmail.com> writes:
>
> Is there any way to get PIO 

I assume you really mean MMIO, not PIO. PIO would be port IO.

> to burst over the PCI bus in the read and
> write direction? 

You should set the MMIO mapping to write combining using an MTRR
You might need to add appropiate memory barriers if you rely
on write ordering though.

-Andi
