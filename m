Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYCNBxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYCNBxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYCNBxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:53:06 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39525 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYCNBxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:53:05 -0400
Date: Thu, 13 Mar 2008 21:53:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
In-Reply-To: <Pine.LNX.4.64.0803140227100.14822@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.1.00.0803132149320.11864@localhost.localdomain>
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain> <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com> <Pine.LNX.4.64.0803140227100.14822@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Jan Engelhardt wrote:

>
> On Mar 14 2008 00:53, Jesper Juhl wrote:
> >I agree with you completely. A file should explicitly include
> >headers for the stuff it uses and not rely on implicit includes
> >done elsewhere. Cleaning that up is going to touch a lot of files
> >though for no real short term gain (there is a long term gain of
> >maintainability though), so it's going to be a loveless job :(
>
> But straightforward. You nuke the complete #include list of a .h/.c
> file and "rebuild" it by hand, by looking at the code the .h/.c file
> provides/uses and selecting appropriate #includes.

well, yes, that would certainly do it, but i'm not that ambitious.
:-)  actually, what i'm testing now is deleting the two superfluous
includes from <linux/percpu.h>:

  #include <linus/slab.h>
  #include <linux/string.h>

doing "make allyesconfig" on x86, watching where the compile fails,
fixing that file, and noticing that errors fall into a fairly small
set of localized clumps, so i'll just collect them and submit them.
there's actually not that many.  patches to follow shortly.

rday
--



========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
