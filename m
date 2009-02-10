Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZBJX4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZBJX4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZBJXzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:55:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbZBJXzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:55:54 -0500
Date: Tue, 10 Feb 2009 15:54:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com,
       kay.sievers@vrfy.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       mingo@elte.hu, mtk.manpages@gmail.com, hch@infradead.org
Subject: Re: LinuxPPS core (Version 2): the PPS Linux implementation.
Message-Id: <20090210155452.60ffa06b.akpm@linux-foundation.org>
In-Reply-To: <1234274752-29847-1-git-send-email-giometti@linux.it>
References: <1234274752-29847-1-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 15:05:51 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> This patch adds the PPS core support into Linux.
> 
> Currently I just propose the "core" so after inclusion we can add all
> other related stuff as suggested by several people in this list. :)
> 
> PPS means "pulse per second" and its API is specified by RFC 2783
> (Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).
> 
> The code has been tested with the NTPD program
> (http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
> antennae.
> 
> 
> Changelog
> =========
> 
> Version 1 -> 2
> --------------
> 
> * fix race during PPS source registration.
> 
> * PPS_CHECK removed.
> 
> * not needed check in pps_exit() removed.
> 
> * Printing stuff on exit removed.
> 
> Version [full patchset] -> 1
> ----------------------------
> 
> * stupid filenames removed.
> 
> * kernel-doc documentation of exported symbols.
> 
> * old BKL-locked ioctl removed.
> 
> * !uarg checks in the ioctls removed.
> 
> * pps.h revisited but not splitted, since several stuff are shared between
>   kernel and user land (I hope this will not stop inclusion...)
> 

Is it hard to do this?  Just a matter of putting some things into
pps_user.h, others into pps_kernel.h and then including both into
pps.h?  


