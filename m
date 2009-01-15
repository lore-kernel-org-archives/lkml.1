Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbZAOPq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbZAOPq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZAOPqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:46:49 -0500
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:32920 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755159AbZAOPqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:46:48 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 10:46:48 EST
Date: Thu, 15 Jan 2009 16:34:06 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: linux kernel without file system
Message-ID: <20090115153405.GA31634@nibiru.local>
Reply-To: weigelt@metux.de
References: <20090114083024.GA30573@frolo.macqel> <20090114101521.5364c04d@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114101521.5364c04d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

Hi,

> > Is there a way to access devices that does not require a file-system ?
> 
> No: but you can run with just your own programs and bits needed loaded
> off an initial ramdisk or a romfs image.

Well, it (IMHO) depends on what you call a filesystem. If you're 
talking about something that stores files (= byte streams with
some assigned name) on some medium, you *could* come around this
(in theory, no idea if it really makes sense): put everything you
need into one big static executable, let the bootloader load it
before the kernel is started (just like initrd ?) and hack up
the kernel to get that damn thing started. 

BUT: it you're talking about the VFS stuff - it's a fundamental
building block of the OS, required in many many places (from 
socket operations to kernel runtime config, ...) - if you *really*
want an OS w/o VFS, you better look at certain embedded-specific
OS'es ;-P

BTW: I'd really like to see much more things handled through the
filesystem (eg. networking API through some /net filesystem, like
on Plan9 ;-p) and let the dozens of syscalls, nelink socket, etc, 
etc die out.


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
