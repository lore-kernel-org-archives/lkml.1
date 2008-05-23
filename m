Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbYEWJaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbYEWJaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYEWJaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:30:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbYEWJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:30:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: Re: [PATCH 5/7] gcov: add gcov profiling infrastructure
Date: Fri, 23 May 2008 11:29:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
References: <48313DE6.30802@de.ibm.com>
In-Reply-To: <48313DE6.30802@de.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231129.54027.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18B6ht2NZt602UHK7d7f7qhF3YPAnH5u04WD9B
 rfiRq9Ggan1Rs7I9MiwHDa3jLmxFRzLmEyDq1bViMm3p3XNjsb
 aP3GoJnDMgfp4f8RDp/gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008, Peter Oberparleiter wrote:
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> gcov profiling infrastructure:
> 
> * change kbuild to include profiling flags
> * provide functions needed by profiling code
> * present profiling data as files in debugfs

Good stuff, thanks for finally pushing this upstream!

Regarding the use of debugfs, have you considered making your
own file system independent of that? Currently, you'd need
a lot of boilerplate code (basically a copy of debugs/inode.c),
but I think it'd be appropriate since you're adding more than
just a few simple files in debugfs.

Maybe we can talk next monday when I'm in the office, because
some time ago, I have already started a patch set that would
make it trivial to add a new debugfs-like file system.

	Arnd <><
