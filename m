Return-Path: <linux-kernel-owner+w=401wt.eu-S932338AbXBYX6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbXBYX6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932765AbXBYX6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:58:51 -0500
Received: from marmot.shef.ac.uk ([143.167.1.4]:50903 "EHLO marmot.shef.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338AbXBYX6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:58:51 -0500
Date: Sun, 25 Feb 2007 23:58:48 +0000 (GMT)
From: "J.J.Green" <j.j.green@sheffield.ac.uk>
X-X-Sender: jjg@parallax.ddns.shef.ac.uk
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64 / bbc_i2c.c
In-Reply-To: <20070225044754.1d849a8d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702252352310.32309@parallax.ddns.shef.ac.uk>
References: <1171978032.18442.11.camel@lax.shef.ac.uk>
 <20070225044754.1d849a8d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-S0phie-Scan: no
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

> The code around there looks relatively unbuggy to me.  Removing that
> remove_wait_queue() would be very bad - it would cause later stack
> corruption.
>
> msleep_interruptible() certainly shouldn't consume CPU like that.  Do we
> know where the CPU time is being spent?  The output of:
>
> readprofile -r
> sleep 10
> readprofile -n -v -m /boot/System.map | sort -n -k 3 | tail -40
>
> would tell us.

As was mentioned in another reply, this message by
Joerg Friedrich

   http://lists.debian.org/debian-sparc/2007/02/msg00045.html

gives a possible explanantion of where the time is going.
I applied the patch to the debian kernel sources for 2.6.18,
it applied cleanly and fixed the problem.

I have the upatched kernel in /boot so I can run the tests
you mentioned fairly easily -- please let me know if you'd
still like me to do that.

Jim
-- 
J.J. Green, Dept. Applied Mathematics, Hicks Bld.,
University of Sheffield, UK.   +44 (0114) 222 3742
http://pdfb.wiredworkplace.net/pub/jjg


