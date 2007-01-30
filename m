Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbXA3T0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbXA3T0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbXA3T0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:26:01 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:31757 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXA3TZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:25:59 -0500
From: Christian Borntraeger <borntrae@de.ibm.com>
To: "Tom Burns" <tom.i.burns@gmail.com>
Subject: Re: Bug: 2.6.15 Process accounting fails to account for small time slice loads (still)
User-Agent: KMail/1.9.5
References: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com>
In-Reply-To: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 30 Jan 2007 20:25:56 +0100
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200701302025.56787.borntrae@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 17:24, you wrote:
> The bug described back in 2004 in the following message still seems to 
exist:
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-05/4313.html
> 
> Essentially, it appears that if a process sleeps before it uses up a
> complete jiffy then no charge is made to its process accounting table.
> 
> This problem still exists in the same manner in kernel:

This is a known limitation of tick based accounting used on most 
architectures. 
It was fixed on s390 and using a cpu timer on every context switch. (IIRC ppc 
is now using this infrastructure as well)

see for a http://www.kernel-traffic.org/kernel-traffic/kt20041117_284.html#8
for the first patch in the series.

I dont know if there are plans of using the infrastructure on x86 compatible 
platforms. I also dont know it that is actually easy to implement with x86 
hardware. 




-- 
Mit freundlichen Grüßen / Best Regards

Christian Borntraeger
Linux Software Engineer zSeries Linux & Virtualization



