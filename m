Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595Ab0ACLGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab0ACLGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 06:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404Ab0ACLGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 06:06:35 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:51020 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0ACLGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 06:06:34 -0500
Subject: =?UTF-8?Q?Re:_[suspend/resume]_Re:_userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <5e82c94e.48c76dcb.4b407a38.aa9ce@o2.pl>
Date: Sun, 03 Jan 2010 12:06:32 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 3 stycznia 2010 11:06 	Daniel Borkmann <danborkmann@googlemail.com> napisał(a):
> Daniel Borkmann wrote:
> > Bartłomiej Zimoń wrote:
> >> What about this discusion:
> >> http://lists.freedesktop.org/archives/devkit-devel/2009-December/000617.html
> >>
> >> I will perform some tests to know what amount of time is usualy needed to disconnect
> >> nicely client or something.
> > 
> > Actually I think this is what signals are there for and bringing this
> > information via signals would have least overhead, problem is that this
> > is not POSIX compliant, but may be you could have a try at this?!
> 
> I'm not quite sure how this is implemented within the kernel, but if you
> have lots of processes doing their suspend routines, I think it is not
> guaranteed that all of this finishes before doing the suspend, so you
> will have some unknown states, processes could stuck at (and later [at
> some unintended point of time] resume on).
> Or, on the other hand you will have to block the kernel notification
> chain until all the procs have signaled that they're done doing their
> jobs. Regarding this, the kernel suspend would depend on the correctness
> / termination of userspace routines which is a _very_ bad thing.
> You will have to introducte some timeouts... see where this is going? I
> think a file interface might be too simple... just some thoughts about this.
> 

mhm, why not to create kernel based pm event messaging for processes?
How it is implemented on other platforms?
Because on MacOsX looks like program registers callback for such event.

I dont know if every pm_notifier blocks suspend until return from callback.

If we cant do it simple we can do it better.
Rafael what do You think about it?

Looks like my email box does not like CC: and others ;/

Best regards.
Bartłomiej Zimoń
PLD Linux, Kadu Team, FreeRunner user
http://kadu-im.blogspot.com/


