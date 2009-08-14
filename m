Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZHNM0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZHNM0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZHNM0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:26:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbZHNM0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:26:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 5/6] new kfifo API v0.3 - add kfifo_skip, kfifo_from_user and kfifo_to_user
Date: Fri, 14 Aug 2009 14:25:42 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
References: <1250250286.19690.96.camel@wall-e>
In-Reply-To: <1250250286.19690.96.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141425.42220.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18d4aJb35QmIqBGFlotUqkj+ku6jVfX7BqYSYu
 Pvlv5TpcnE37e4l4g9t1aX8QLr84W3KylOkEUbelBYvyPvbOuq
 LklMQvPQs8Ccrg8SoxAOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Stefani Seibold wrote:
> This is patch 5/6 of the new kfifo API:
>  kfifo_reset_out() to lockless save discard the fifo output
>  Add kfifo_skip() to skip a number of output bytes
>  Add kfifo_from_user() to copy user space data into the fifo
>  Add kfifo_to_user() to copy fifo data to user space
>  Do some code reorg

kfifo_skip is missing a comment regarding what it does,
and as with the other patches, the description should
line out why this is done, not what you do.

> Signed-off-by: Stefani Seibold <stefani@seibold.net>
 
Otherwise,
Acked-by: Arnd Bergmann <arnd@arndb.de>
