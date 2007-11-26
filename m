Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbXKZRs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbXKZRs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXKZRsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:48:52 -0500
Received: from bay0-omc2-s19.bay0.hotmail.com ([65.54.246.155]:15208 "EHLO
	bay0-omc2-s19.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbXKZRsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:48:51 -0500
Message-ID: <BLU103-DAV9F8A12C3BFA4AAAC0B7B4D6750@phx.gbl>
X-Originating-IP: [130.13.252.143]
X-Originating-Email: [joshin@hotmail.com]
From: "Josh Goldsmith" <joshin@hotmail.com>
To: "David Newall" <david@davidnewall.com>, <pavel@ucw.cz>
Cc: <linux-kernel@vger.kernel.org>
References: <BLU103-DAV550703C13BE5EF0DDF51AD6740@phx.gbl> <474AB4A3.8050802@davidnewall.com>
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
Date: Mon, 26 Nov 2007 10:48:34 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-OriginalArrivalTime: 26 Nov 2007 17:48:50.0400 (UTC) FILETIME=[9A4A3600:01C83054]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David:  The exact command this time was a "tar jxf linux-2.6.23.tar.bz2" as 
part of an emerge (gentoo).  Gnu tar version 1.18 but has happened with 
prior versions too.  I replicated it after my post by manually untarring it 
on the command line and can almost always replicate the problem with any 
large (GCC/kernel) tarball.  If I shut down all other processes, the untar 
will go longer but eventually the oom-killer will be invoked.

Pavel:  I'll ping Olver Neukum about it.

Thanks for the responses!
  -Josh

----- Original Message ----- 
From: "David Newall" <david@davidnewall.com>
To: "Josh Goldsmith" <joshin@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>
Sent: Monday, November 26, 2007 4:57 AM
Subject: Re: Small System Paging Problem - OOM-killer goes nuts


> Josh Goldsmith wrote:
>> The problem comes when I try to untar a large file (in this case 
>> linux-2.6.23.tar.bz2).  Regardless if I kill off every other process, 
>> eventually the oom-killer will appear and kill either the tar or the 
>> shell.
>
> What's the actual command you are executing?
> 

