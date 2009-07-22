Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZGVXFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZGVXFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZGVXFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:05:16 -0400
Received: from imp01.mtu.ru ([62.5.255.10]:43823 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZGVXFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:05:15 -0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
Date: Thu, 23 Jul 2009 03:05:09 +0400
User-Agent: KMail/1.9.10
References: <200907221926.50397.pavel@pavlinux.ru> <20090722231738.21de4deb@lxorguk.ukuu.org.uk> <20090722222807.GB20860@redhat.com>
In-Reply-To: <20090722222807.GB20860@redhat.com>
X-Face: =?utf-8?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU2S=5D=27?=
 =?utf-8?q?=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=249HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?utf-8?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5DzA=25=0A=09?=
 =?utf-8?q?Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?utf-8?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907230305.10821.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 July 2009 02:28:07 Dave Jones wrote:
[cut]
>  > Not only
>  > that but CONFIG_AGP controls the display of AGP video card options so it
>  > is a selection for offered devices not really an internal detail.
>
> CONFIG_AGP has _nothing_ to do with video card options.

For example, proprietary nvidia  driver needed struct agp_bridges, 
exported from  drivers/char/agp/backend.c

After loading the nvidia, load agpgart (if CONFIG_AGP set as module) 

