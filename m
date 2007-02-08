Return-Path: <linux-kernel-owner+w=401wt.eu-S1422929AbXBHPA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422929AbXBHPA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423008AbXBHPA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:00:59 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45764 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422929AbXBHPA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:00:58 -0500
Message-ID: <45CB3B28.60102@garzik.org>
Date: Thu, 08 Feb 2007 10:00:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: somebody dropped a (warning) bomb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just did a pull for the first time since 2.6.20, and a /megaton/ of new 
warnings have appeared, on Fedora Core 6/x86-64 "make allyesconfig".

All of the new warnings spew appear to be "pointers differ in 
signedness" warning.  Granted, we should care about these, but even a 
"silent" build (make -s) now spews far more output than any human could 
possibly care about, and digging important nuggets out of all this noise 
is beginning to require automated tools rather than just human eyes.

	Jeff


