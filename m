Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbXD0Gvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbXD0Gvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbXD0Gvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:51:35 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37591 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbXD0Gvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:51:33 -0400
Date: Fri, 27 Apr 2007 08:49:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andi Kleen <ak@suse.de>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] x86_64: kill 19000+ sparse warnings
In-Reply-To: <200704261124.52386.ak@suse.de>
Message-ID: <Pine.LNX.4.61.0704270849100.506@yvahk01.tjqt.qr>
References: <20070425224509.46153baa.randy.dunlap@oracle.com>
 <200704261124.52386.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 26 2007 11:24, Andi Kleen wrote:
>On Thursday 26 April 2007 07:45:09 Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>> 
>> Eliminate 19439 (!!) sparse warnings like:
>> include/linux/mm.h:321:22: warning: constant 0xffff810000000000 is so big it is unsigned long
>
>Sparse is just wrong here. The C standard does make it unsigned long long
>automatically

Wish it did...

(32bit i386):
08:47 ichi:/dev/shm > cat foo.c
unsigned long long a = 0x123456789;
08:47 ichi:/dev/shm > cc -c foo.c -Wall
foo.c:1: warning: integer constant is too large for ‘long’ type
Or is this something else?

Jan
-- 
