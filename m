Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXI2AIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXI2AIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXI2AIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:08:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXI2AH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:07:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [COMPAT] Add compat_merge64 helper
Date: Sat, 29 Sep 2007 01:52:12 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1191018832-18069-1-git-send-email-kyle@mcmartin.ca> <200709290138.24562.arnd@arndb.de> <20070929000131.GD25346@fattire.cabal.ca>
In-Reply-To: <20070929000131.GD25346@fattire.cabal.ca>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709290152.12842.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/03vR28nA3vbJpeFhuRICNZc09agX9qOJmStJ
 4/U5bLiWJOkaGyJWc5Ntf2MxpYWtBBrrhEeB8EhYSmzgXEUevb
 WTWVY/x9dWSaGs56stDmQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007, Kyle McMartin wrote:
> 
> On Sat, Sep 29, 2007 at 01:38:23AM +0200, Arnd Bergmann wrote:
> > 1. Byte order matches the order in which 64 bit arguments are split
> >    in system call conventions on all platforms.
> 
> I checked powerpc, sparc, and mips, which are (besides parisc) the only
> 64-bit with 32-bit userspace big endian architectures that I could think
> of offhand. A quick grep shows sh64 too... Paul?
> 

s390 is big-endian as well, and while it does have really weird C calling
conventions for 64 bit arguments in 32 bit mode, these do not affect the
system call ABI, so we should be fine here.

ia64 and x86_64 are obviously little-endian, and I double-checked that they
work with this logic.

	Arnd <><
