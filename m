Return-Path: <linux-kernel-owner+w=401wt.eu-S964855AbXBYOAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbXBYOAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 09:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964856AbXBYOAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 09:00:09 -0500
Received: from smtp.galliera.it ([62.101.86.54]:34675 "EHLO smtp.galliera.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964855AbXBYOAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 09:00:07 -0500
X-Greylist: delayed 1569 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Feb 2007 09:00:07 EST
Date: Sun, 25 Feb 2007 14:33:29 +0100
From: Emanuele Rocca <ema@debian.org>
To: "J.J. Green" <j.j.green@sheffield.ac.uk>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re:  sparc64 / bbc_i2c.c
Message-ID: <20070225133329.GA22364@darkmoon.home>
Mail-Followup-To: "J.J. Green" <j.j.green@sheffield.ac.uk>,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
References: <1171978032.18442.11.camel@lax.shef.ac.uk> <20070225044754.1d849a8d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070225044754.1d849a8d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>, [2007-02-25  4:47 -0800]:
>  > On Tue, 20 Feb 2007 13:27:12 +0000 "J.J. Green" <j.j.green@sheffield.ac.uk> wrote:
>  > I got bitten by this problem on sparc64 (a blade 1000)
>  > 
>  >   http://ubuntuforums.org/showthread.php?t=297474

>  The code around there looks relatively unbuggy to me.  Removing that
>  remove_wait_queue() would be very bad - it would cause later stack
>  corruption.

The following patch by Jörg Friedrich fixes the issue without removing
the call to remove_wait_queue():

http://lists.debian.org/debian-sparc/2007/02/msg00045.html

ciao,
    ema
