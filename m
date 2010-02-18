Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0BRNUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 08:20:42 -0500
Received: from relay01.mx.bawue.net ([193.7.176.67]:55643 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0BRNUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 08:20:41 -0500
Date: Thu, 18 Feb 2010 14:20:32 +0100
From: lkml@Think-Future.de
To: Linux Kernel-Liste <linux-kernel@vger.kernel.org>
Subject: kernel/xserver-xorg: X crash while either idle or busy
Message-ID: <20100218132032.GE2165@localhost>
Reply-To: lkml@Think-Future.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

This bug report has been posted to the debian bugtracker for the
x-server-org deb package:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=570124

This link contains an extensive bug-report together with any relevant
information available.

The description is:

# Package: xserver-xorg
# Version: 1:7.5+2
# Severity: severe
# 
# Data loss guaranteed. While writing a book, X crashed, part of the book had
# to be re-written.
# 
# Whether using the system or not, X crashes semi-reproducibly. Be it after a 
# suspend-resume cycle or while just browsing the net, using openoffice writer, 
# doing nothing.. It just keeps crashing one day or the other. Mean times between
# crashing is from 2 hours to 2 days, sometimes more, sometimes less.
# 
# When the system crashes after opening the cover/lid it usually takes the whole kernel 
# down. Reboot only.
# 
# Less often but often enough, the crashing X just hangs, locking the
# system up. Reboot only.
# 
# This is occurring since january 2009 (switch-over to linux) over a variety of 
# kernel, kms, intel-drv and X versions. May well be different causes but 
# seems quite the same to us..
# 
# System is a rather usual ACER Extensa 5220 notebook.

A complete bug-report is available via the above link. 

The answer - among other ideas - was that if the kernel is 
hanging/freezing it is supposed to be reported to the lkml.

So posting here, fyi.

Thank you.

Nils

