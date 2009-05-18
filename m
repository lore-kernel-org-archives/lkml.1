Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZERI0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZERI0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZERIZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:25:55 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:38685 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZERIZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lxvvgEmT77Z6s83LEbgZZ6KF3ic6a4d56G6CkyQPKsjuqd7OQN5LjfxD7XdESjHNqj
         x7aV7FgOPgZjZNEcSlMUV2r9nJ+G3CprXQPj4Q6PrB/Ey3Yd15ZAqrj0tACQ40vpXpdS
         6qmAGLqNb3za3VARzL3qtoT/yE2GO9GaekA7s=
MIME-Version: 1.0
Date: Mon, 18 May 2009 04:25:51 -0400
Message-ID: <3d2f29dc0905180125x5e7ef51dqf10955a3d44336e2@mail.gmail.com>
Subject: Boot problems with 2.6.29.1 - cannot smoothly boot on battery
From: Chris Howie <cdhowie@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks:

I've been running 2.6.29.1 for some time and reported an issue to this
mailing list a while ago about the boot process.  I believe I have now
nailed down the one factor that determines whether I see this issue.

The problem arises only when booting or halting my laptop when there
is no power plugged in, e.g. the system is running on battery.
Sometime after init begins starting services I must hold down a key on
the keyboard to convince it to continue booting, otherwise it just
hangs.  If the system is running on AC then it boots fine.  This same
problem repeats itself during the halt process if running on battery.

This also happens when resuming a suspend-to-disk image, after loading
the data from the hard drive, but before control is returned to
userspace.  The keyboard has no effect on this hang, presumably
because the kernel is not listening to the keyboard at this point.
When this happens the only solution is to hold the power button and
boot normally instead.

An issue like this is a serious usability problem for me.  I am
neither a kernel developer nor hacker, my coding skills applying
mostly to userspace applications.  If there is anything you need from
me to help diagnose this problem please let me know.

I am not subscribed so please CC me on replies.

Thanks all for your time,

-- 
Chris Howie
http://www.chrishowie.com
http://en.wikipedia.org/wiki/User:Crazycomputers
