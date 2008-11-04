Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYKDMrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYKDMrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKDMrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:47:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52243 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYKDMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:47:10 -0500
Date: Tue, 4 Nov 2008 12:47:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <aj504@cs.york.ac.uk>
Cc: linux-kernel@vger.kernel.org, linux-testers@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
Message-ID: <20081104124706.GB19401@srcf.ucam.org>
References: <bspwK-420-11@gated-at.bofh.it> <bujnh-2fr-5@gated-at.bofh.it> <bujwT-2Ew-5@gated-at.bofh.it> <buml1-6du-3@gated-at.bofh.it> <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 03:29:23AM -0800, Alan Jenkins wrote:

> I've tested pciehp with this patch on my EeePC, which as you say uses
> pcie hotplug to allow power savings when the wireless is not needed.
> Functionally it seems ok.

Hurrah. Progress.

> But resuming from suspend to ram can now take 15-20 seconds.  It seems
> the longer suspend time happens with the device "present"; it's about
> 5 seconds shorter with the device "removed", but still much longer
> than previously.  There's more than one PCIE port, so the rest of the
> delay could be due to other ports which always have devices "present".

Mm. Yeah, a printk with timings would probably be a good plan. I'll do 
some poking at this end and see where the time seems to be being lost.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
