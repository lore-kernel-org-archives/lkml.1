Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbXBVVjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbXBVVjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXBVVjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:39:07 -0500
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:43558 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXBVVjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:39:05 -0500
X-Greylist: delayed 999 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 16:39:04 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Patch 1/2] cciss: fix for 2TB support
Date: Thu, 22 Feb 2007 21:22:19 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C5C80F7@G3W0639.americas.hpqcorp.net>
In-reply-to: <20070222201809.GA1530@beardog.cca.cpqcorp.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 1/2] cciss: fix for 2TB support
Thread-Index: AcdWvpLMoRxJTAhKTo23iCDj5M2CuAACMigg
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net> <20070221191427.9b7cf4b0.akpm@linux-foundation.org> <20070222201809.GA1530@beardog.cca.cpqcorp.net>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <jens.axboe@oracle.com>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <gregkh@novell.com>
X-OriginalArrivalTime: 22 Feb 2007 21:22:20.0344 (UTC) FILETIME=[892FCB80:01C756C7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Mike Miller (OS Dev) [mailto:mikem@beardog.cca.cpqcorp.net] 
> 
> Andrew,
> Using this test program and changing the type of x to int, 
> long, long long signed and unsigned the comparison always 
> worked on x86, x86_64, and ia64. It looks to me like the 
> comparsion will always do what we expect. Unless you see some 
> other problem.
> 
> 
> #include <stdio.h>
> 
> int main(int argc, char *argv[])
> {
> 	unsigned long long x;
> 	
> 	x =  0x00000000ffffffff;
> 
> 	printf(sizeof(x) == 8 ? 
> 		"x = %lld, sizeof(x) = %d\n" :
> 		"x = %ld, sizeof(x) = %d\n",  x, sizeof(x));
> 	if (x == 0xffffffff)
> 		printf("equal\n");
> 	else
> 		printf("not equal\n");
> 	
> }
> 
> -- mikem
> 
BTW: also changed x to be 8 f's, 16 f's, and 8 and 8 as shown.
