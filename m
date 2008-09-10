Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbYIJJTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbYIJJTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYIJJTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:19:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:55308 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYIJJTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=AeXODiEbz8oFo0aNMHpZg5auZ1+8kzjPsP3W2GQNuNXVtSu8efwofWXjImZapEaxBZ
         qk254M100exUhzGf1YbCey1oKN3VgaCz/bAWiTmX1OMzqnoszuYPwaml6l88zsHR2Ifd
         vjkR4D7aQYEiv6jYdbk60onoM/wdOcAdYKUb8=
Date: Wed, 10 Sep 2008 11:19:02 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: John Wenker <jjw@pt.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: fstat(2) returns st_size==0 for non-empty FIFO.
Message-ID: <20080910111902.6916284a@Varda>
In-Reply-To: <OFA045C5CB.E26ECC40-ON882574BF.007A7015-882574BF.007ED085@pt.com>
References: <OFA045C5CB.E26ECC40-ON882574BF.007A7015-882574BF.007ED085@pt.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 9 Sep 2008 16:05:06 -0700
John Wenker <jjw@pt.com> escribió:

> A colleague has run into a problem.  We assume it's a kernel issue.  Here 
> is the pertinent bug report data.
> 
> [1.] One line summary of the problem:
> fstat(2) returns st_size == 0 for a FIFO that is known to have data in it.
> 
> [2.] Full description of the problem/report:
> When using a FIFO, fstat(2) (and stat(2)) returns a 'struct stat' with the 
> st_size field equal to zero, at a time when the FIFO is known to have data 
> in it.  Problem occurs with Linux 2.6.16 kernel (see more below), but does 
> not occur on 2.4.20.
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> stat, fstat, FIFO, struct stat, st_size, system call, write
> 
> [4.] Kernel version (from /proc/version):
> Linux version 2.6.16.13-4-default (geeko@buildhost) (gcc version 4.1.0 
> (SUSE Linux)) #1 Wed May 3 04:53:23 UTC 2006
> 
> Note: Problem does _not_ occur on Linux version 2.4.20-8 
> (bhcompile@porky.devel.redhat.com) (gcc version 3.2.2 2003022 (Red Hat 
> Linux 3.2.2-5)) #1 Thu Mar 13 17:54:28 EST 2003
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information 
>      resolved (see Documentation/oops-tracing.txt)
> No oops.  Problem doesn't cause system crash, only affects behavior of 
> user applications.
> 
> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> I don't know if this qualifies as "small", but there is a 'C' program 
> attached that will reproduce the problem (fifo.c).

 FWIW
 $ LC_ALL=C ./fifo test
 Enter a string to write into the FIFO: Hello World!        
 fifo: WARNING - 0 (of 14 requested) bytes written into FIFO.
 0 bytes in FIFO.
 $ uname -r                                                                                
 2.6.27-rc5
                                                                                          

 
 

> 
> 
> 
