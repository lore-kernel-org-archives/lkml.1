Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYJXMvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYJXMvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYJXMvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:51:46 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:51862 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750808AbYJXMvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:51:45 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 08:51:44 EDT
Date: Fri, 24 Oct 2008 14:45:02 +0200
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: MCEs
Message-ID: <20081024124502.GA9425@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting frequent MCEs on my Linux desktop, when I am encoding TV
recordings to H.264 using mencoder.  It is a dual core box, I am using
2.6.27 (but have had the problem for a while now).

This is the kind of MCE that freezes the box and causes a panic.  The
trace does not end up in syslog.  I found a program called mcelog which
I am supposed to call regularly from cron, but how can that help me when
the first MCE I get insta-panics the box?

Now the most common causes for MCEs are apparently heat issues and bad
memory.  I can rule out both.  Could this be an artifact of some bad
ACPI tables?

How do you debug this kind of problem?

Thanks,

Felix
