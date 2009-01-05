Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZAEOeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZAEOeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbZAEOdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:33:43 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58308 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbZAEOdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:33:42 -0500
Date: Mon, 5 Jan 2009 14:33:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jike Song <albcamus@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.28 hates my RTC clock - with PM_TRACE set
Message-ID: <20090105143338.GA32337@srcf.ucam.org>
References: <df9815e70901050619v6c60e8d4w6868759bb3c36bdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9815e70901050619v6c60e8d4w6868759bb3c36bdb@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:19:22PM +0800, Jike Song wrote:

> As usually, it suspended to RAM successfully.  But after I press the
> power button, it won't come back, giving me nothing but a black
> screen.  So I hold the power button done for about 5 seconds, then the
> computer halted(it's only a hardware feature of the southbridge,
> right? ;-), silently, without any output on the always-black screen.
> 
> So the PM_TRACE code was broken, right?

Why do you say that?

> After rebooting the computer, I found I was in the year 1988!  And I
> do the suspend-hold_power_button-reboot once again, now it is 2040
> years A.D.

PM_TRACE uses the clock registers to store information about which 
device the kernel was attempting to resume when it hung. It's expected 
that your clock will be wrong afterwards.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
