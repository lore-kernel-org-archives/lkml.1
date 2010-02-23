Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0BWQri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:47:38 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61091 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0BWQrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:47:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZBwNSZLWbQJOdGFUnGIMr29y2wflPbHl5XW2kopapGnjVxAZ5B400ZjHVQtCgpQ41u
         I8xbO2ffnrVe36f8Bqa2uIbKUZ0FF9xty9Fmpj/ouULb3TdE59ZcZLKvEN13GyGd4WwN
         j7Or+1vMv6g7E4YLRlyx744Ne4XXWQJmmgSFw=
MIME-Version: 1.0
Date: Tue, 23 Feb 2010 18:47:34 +0200
Message-ID: <912ec82a1002230847h11d0f628rbd38b12f38270735@mail.gmail.com>
Subject: sysfs vs. ioctl
From: Neshama Parhoti <pneshama@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

we are in the process of writing a new driver and we don't know
whether to choose a sysfs or ioctl interface to user space.

we know that sysfs is preferred, but we're concerned it will have bad
performance when compared to ioctl (our driver will have its interface
might be used many dozens of times per second, possible even more than
100 times per second).

so should we opt for ioctls if a usage is expected even every 5
miliseconds (in extreme scenarios) ?

thank you in advance for the help
~pnesh
