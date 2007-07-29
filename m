Return-Path: <linux-kernel-owner+w=401wt.eu-S936133AbXG2VAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936133AbXG2VAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXG2VAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:00:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbXG2VAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:00:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [2.6 patch] arch/powerpc/Kconfig: fix the EMBEDDED6xx dependencies
Date: Sun, 29 Jul 2007 21:31:37 +0200
User-Agent: KMail/1.9.6
Cc: Adrian Bunk <bunk@stusta.de>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20061201115410.GV11084@stusta.de> <17779.37050.4039.942954@cargo.ozlabs.ibm.com> <20070728152704.GA30976@stusta.de>
In-Reply-To: <20070728152704.GA30976@stusta.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292131.38348.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX195Lt7fGpL0zbKqcouGqeC8BDiXcC7G+Waw+gy
 Psb1nXYXLSDLt163QZaJRDr5aIRqB71sQmS9IahtFucxsm9u8I
 au2inWLWJOpaaWpqh/sRg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 July 2007, Adrian Bunk wrote:
> On Mon, Dec 04, 2006 at 02:06:34PM +1100, Paul Mackerras wrote:
> > Adrian Bunk writes:
> > 
> > > This patch changes the EMBEDDED6xx dependencies to the equivalent 
> > > dependency that seems to have been intended.
> > 
> > Nack - CONFIG_EMBEDDED6xx is going away entirely, soon.
> 
> Still there - and still with this strange dependency.

The last time I sent my patch to clean up CONFIG_EMBEDDED6xx and a few
other Kconfig options I still left it intact, but it becomes unnecessary
after that.

I still think that having high-level options like

* embedded6xx
  * MPC7448HPC2
  * holly
  * linkstation
* PPC_83xx
  * MPC8313_RDB
  * MPC832x_MDS
  * MPC832x_RDB

helps keep the platform selection more structured and readable, but the
dependency on !SMP should probably go into the individual platforms that
are actually broken, if any, not into the high-level option.

	Arnd <><
