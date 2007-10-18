Return-Path: <linux-kernel-owner+w=401wt.eu-S1761224AbXJRGMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbXJRGMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 02:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbXJRGLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 02:11:43 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:59119 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbXJRGLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 02:11:42 -0400
X-Greylist: delayed 4783 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 02:11:41 EDT
Message-ID: <4716E66B.9060905@nttdata.co.jp>
Date: Thu, 18 Oct 2007 13:51:55 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@surriel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
References: <20071014190128.6e3cdb44@bree.surriel.com>
In-Reply-To: <20071014190128.6e3cdb44@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2007 04:51:56.0180 (UTC) FILETIME=[9BF07540:01C81142]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2007 8:01 AM, Rik van Riel wrote:
 > The kernel newbies community often gets inquiries from CS students who
 > need a project for their studies and would like to do something with
 > the Linux kernel, but would also like their code to be useful to the
 > community afterwards.
 >
 > In order to make it easier for them, I am trying to put together a
 > page with projects that:
 > - Are self contained enough that the students can implement the
 >   project by themselves, since that is often a university requirement.
 > - Are self contained enough that Linux could merge the code (maybe
 >   with additional changes) after the student has been working on it
 >   for a few months.
 > - Are large enough to qualify as a student project, luckily there is
 >   flexibility here since we get inquiries for anything from 6 week
 >   projects to 6 month projects.
 >
 > If you have ideas on what projects would be useful, please add them
 > to this page (or email me):
 >
 > http://kernelnewbies.org/KernelProjects

Well, I know something that might be interesting for kernel newbies
including students. So let me share it with you.
It's Ubuntu 7.04 based LiveCD with TOMOYO Linux kernel.

Directions:
1. visit the following URL and save ISO image
    http://tomoyo.sourceforge.jp/wiki-e/?TomoyoLive
2. burn CD/DVD and boot from the disc
    (or start up VM from the downloaded image)
3. open "TOOMYO Linux Policy Editor" icon on the gnome desktop
4. browse "domains" with cursor keys
    you can see how processes were created (great experience)
5. choose a domain and enter return key
    you can see the behavior of the selected "domain" (ACL mode)
6. enter return to step 5 (domain transition mode)
    (repeat 5-7 as you like, type 'r' to refresh screen)
7. enter q to quit the editpolicy program

As it's LiveCD like KNOPPIX, hard disks will not be
affected unless you mount them and operate with intention.
I mean, it's safe to play with.

What makes all of these possible is "TOMOYO Linux",
but you don't have to understand it. ;)
No policy definition, preparation, knowledge or hustle is
required.

If you are interested in TOMOYO Linux (just in case...),
please visit our Wiki page.
http://tomoyo.sourceforge.jp/wiki-e/?WhatIs

Cheers,
Toshiharu Harada
