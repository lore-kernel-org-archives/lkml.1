Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZGVXPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZGVXPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZGVXPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:15:47 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:34426 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbZGVXPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:15:47 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
Content-Disposition: inline
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
X-Face: =?utf-8?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU2S=5D=27?=
 =?utf-8?q?=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=249HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?utf-8?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5DzA=25=0A=09?=
 =?utf-8?q?Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?utf-8?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
Date: Thu, 23 Jul 2009 03:15:43 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200907230315.44654.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 July 2009 02:17:38 you wrote:
> On Wed, 22 Jul 2009 17:37:46 -0400
>
> Dave Jones <davej@redhat.com> wrote:
> > On Wed, Jul 22, 2009 at 07:26:49PM +0400, Pavel Vasilyev wrote:
> >  > In the kernel configuration, if I choose x86_64 and PCI, then choose
> >  > the item "Garth IOMMU support", which, in turn, chooses not to switch
> >  > off, support for AGP. But many IOMMU system does not have AGP bus.
> >
> > The lack of AGP slots doesn't mean a lack of AGP bus.
> > It's part of the K8 on-CPU northbridge.
>
> And the user is selecting CONFIG_AGP to select AGP devices rather than to
> demonstrate their deep guru grade knowledge of K8 northbridges. Not only
> that but CONFIG_AGP controls the display of AGP video card options so it
> is a selection for offered devices not really an internal detail.
>
> So I think Pavel is right here.


May be  next logic 

 IF  ( GART_IOMMU  == TRUE )  
    THEN  
            IF ( AGP == TRUE ) 
               THEN 
                        AGP_AMD64 = TRUE;
           FI
FI 

Now 

 IF  ( GART_IOMMU  == TRUE )  
    THEN  
              AGP = TRUE;'
	AGP_AMD64 = TURE;
FI
 

And in bytes is 

-rw-r--r-- 1 root root 54322 Jul 23 01:21 agpgart.ko
-rw-r--r-- 1 root root 19745 Jil 23 01:21  amd64-agp.ko 

 is  74067 bytes  :)

