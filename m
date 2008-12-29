Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbYL2Pqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbYL2Pqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYL2Pqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:46:35 -0500
Received: from www.tglx.de ([62.245.132.106]:35660 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYL2Pqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:46:35 -0500
Date: Mon, 29 Dec 2008 16:46:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Roth <mroth@nessie.de>
cc: Andrew Drake <zappacky.lists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Funny problem with 2.6.28: Kernel stalls
In-Reply-To: <4958B9B7.8060505@nessie.de>
Message-ID: <alpine.LFD.2.00.0812291636060.3723@localhost.localdomain>
References: <4953A35C.8090005@nessie.de> <495411FD.60409@gmail.com> <4958B9B7.8060505@nessie.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, Michael Roth wrote:
> Andrew Drake schrieb:
> > Michael Roth wrote:
> >> The funny part: If I hit any key (on the keyboard connected by USB) the
> >> kernel resumes to normal work until the next stall.
> >>
> > 
> > This sounds a little bit like my old problem... try kernel option nolapic_timer.
> > It worked for me, perhaps it can do the same for you.
> 
> I didn't checked nolapic_timer (yet), but found these small changes to
> the kernel config do the trick for me:
 
Can you please provide the following information from the kernel which
shows these freeze symptoms:

output of: dmesg
output of: cat /proc/timer_list

Thanks,

	tglx
