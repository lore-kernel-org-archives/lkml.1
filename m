Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYADQXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYADQXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYADQW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:22:59 -0500
Received: from mail.suse.de ([195.135.220.2]:51495 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbYADQW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:22:58 -0500
To: felix-linuxkernel@fefe.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: memory remapping, 4gb memory on 945gt
From: Andi Kleen <andi@firstfloor.org>
References: <20080104154914.GA589@codeblau.de>
Date: Fri, 04 Jan 2008 17:22:57 +0100
In-Reply-To: <20080104154914.GA589@codeblau.de> (felix-linuxkernel@fefe.de's message of "Fri\, 4 Jan 2008 16\:49\:14 +0100")
Message-ID: <p73lk758sri.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

felix-linuxkernel@fefe.de writes:

> I recently put 4 GB of memory in my Acer Travelmate 8210 series
> notebook.  The BIOS only detects 3 GB.

Actually it will detect 4GB, but put the PCI hole over the last GB.
One way to get more usable memory is to configure the BIOS to use a smaller
PCI hole (e.g. use smaller frame buffer/aperture etc.)

> I googled around a little.  It appears to be a chipset limitation of the
> 945gt, which uses the fourth gig for devices.
>
> Now I can understand this explanation for 32-bit mode, but I'm running
> in 64-bit mode.  There should be a way to use the fourth gig under
> Linux.  Is there?

The chipset limitation applies to 64bit mode as well as to 32bit mode
(which actually does not have a 4GB limitation with PAE)

-Andi
