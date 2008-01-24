Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYAXGt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYAXGt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYAXGtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:49:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbYAXGtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:49:19 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] x86: ignore spurious faults
From: Andi Kleen <andi@firstfloor.org>
References: <4797D64D.1060105@goop.org>
Date: Thu, 24 Jan 2008 07:49:17 +0100
In-Reply-To: <4797D64D.1060105@goop.org> (Jeremy Fitzhardinge's message of "Wed\, 23 Jan 2008 16\:05\:33 -0800")
Message-ID: <p73hch3afbm.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
> /*
> + * Handle a spurious fault caused by a stale TLB entry.  This allows

vmalloc_fault already has nearly the same logic. You should look
at sharing the code.

-Andi
