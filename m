Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbYJXVpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbYJXVpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbYJXVo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:44:26 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:39917 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756522AbYJXVoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:44:25 -0400
Date: Fri, 24 Oct 2008 23:44:22 +0200
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MCEs
Message-ID: <20081024214422.GA20599@codeblau.de>
References: <20081024124502.GA9425@codeblau.de> <87r66598eq.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r66598eq.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is the kind of MCE that freezes the box and causes a panic.  The
> > trace does not end up in syslog.  I found a program called mcelog which
> > I am supposed to call regularly from cron, but how can that help me when
> > the first MCE I get insta-panics the box?
> When you do a warm boot (not power cycle, but reset button or 
> panic=30) then the panic mce will be logged after reboot.

Maybe I'm doing something wrong here.
I run mcelog from the shell after the boot.
Nothing happens, I get the shell prompt right back.

How do I know it's really a MCE?  So far my symptoms are: the machine
freezes, then a panic dump scrolls by, and the only text I can see on my
screen are the stack dump lines, which contain something to the tune of
machine_check() or so.  Nothing shows up in syslog, probably the kernel
decides the box is too hosed to log anything.

Felix
