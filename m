Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYBTILr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYBTILr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYBTILk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:11:40 -0500
Received: from www.tglx.de ([62.245.132.106]:33142 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYBTILi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:11:38 -0500
Date: Wed, 20 Feb 2008 09:11:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Quel Qun <kelk1@comcast.net>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
In-Reply-To: <alpine.LFD.1.00.0802200108040.7583@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0802200908250.7583@apollo.tec.linutronix.de>
References: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net> <alpine.LFD.1.00.0802181245370.7583@apollo.tec.linutronix.de> <895FB10F-5E5C-4409-AC3E-5F83BBF9ED72@holtmann.org>
 <alpine.LFD.1.00.0802200108040.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Thomas Gleixner wrote:
> On Tue, 19 Feb 2008, Marcel Holtmann wrote:
> > I don't really have any idea. Nothing has been changed in this area for a
> > couple of years. The command TX timeout is the timeout that indicates a
> > missing answer to a command sent down to the Bluetooth chip.
> > 
> > However this involves some atomic and tasklet stuff. Did we have some changes
> > that I missed and might now render this usage as broken.
> 
> Not that I'm aware off, but this might as well be some old use after
> free bug which got exposed by some unrelated change. The good news is
> that it is reproducible. I'll hack up some nasty debug patch which
> lets us - hopefully - decode where the timer was armed.

Quel, before I do that, is there any chance that you retest with the
latest mainline git version ?

http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc2-git4.bz2

Is the delta which applies on top of rc2.

Thanks,

	tglx
