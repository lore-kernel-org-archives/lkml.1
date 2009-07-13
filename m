Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780AbZGMFrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbZGMFrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 01:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbZGMFrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 01:47:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43923 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZGMFrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 01:47:12 -0400
To: stern@rowland.harvard.edu
CC: miklos@szeredi.hu, linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.44L0.0907101052500.2906-100000@iolanthe.rowland.org>
	(message from Alan Stern on Fri, 10 Jul 2009 10:56:42 -0400 (EDT))
Subject: Re: usb mouse not responding after resume
References: <Pine.LNX.4.44L0.0907101052500.2906-100000@iolanthe.rowland.org>
Message-Id: <E1MQENX-0008Up-N8@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 13 Jul 2009 07:47:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Alan Stern wrote:
> On Fri, 10 Jul 2009, Miklos Szeredi wrote:
> 
> > Sometimes after resume the usb mouse plugged into my T60 notebook
> > isn't working.  Unplugging and replugging it fixes the problem.  A
> > keyboard is also plugged in, which works normally every time.
> > 
> > This has been happening on and off from about 2.6.30-rc* but in
> > 2.6.31-rc* seems to be getting more frequent.
> 
> Looks like something is wrong with the mouse itself.

Hmm, could well be, this is not a young mouse and had some problems
(fits of random movements) all of its life.

> > Here's the suspend-resume-replug part of the dmesg.  Not sure if it is
> > enough, I'd be happy to provide more info.
> 
> The log showed that the mouse disconnected itself during the suspend.  
> But then after the resume it reconnected -- presumably this log shows a
> cycle where the mouse _was_ working afterward.

No it wasn't, if you look at the timestamps it reconnected only after
some time after resume.  That is because when it wasn't working I
unplugged it and then plugged it back.

> 
> Can you provide a similar log for a cycle where the mouse _didn't_ 
> respond afterward?  It might not help much, however; most likely it 
> will show that the mouse disconnects itself during the suspend and then 
> doesn't reconnect.
> 
> Have you tried plugging the mouse into a different USB port?  It might 
> help.

Okay, will try that and see if it helps.  Maybe I should get a new
mouse too... :)

Thanks,
Miklos
