Return-Path: <linux-kernel-owner+w=401wt.eu-S965732AbXHaRK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965732AbXHaRK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932625AbXHaRKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:10:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbXHaRKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:10:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joachim Fenkes <FENKES@de.ibm.com>
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
Date: Fri, 31 Aug 2007 19:08:04 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070508.662491)
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
References: <OFBB1BA4B6.29175A76-ONC1257348.004DBCB3-C1257348.0050161C@de.ibm.com>
In-Reply-To: <OFBB1BA4B6.29175A76-ONC1257348.004DBCB3-C1257348.0050161C@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311908.05255.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18UAaJQ2XDrc8K/Vmn6antvGeWC+kDRm6OG6dU
 QRi0WUkC5vKdetlcRYPZ9LvouMX/ZhBkrvLtpc9EvIaov+WZaQ
 WPBodHOofO+GroTwrRPkw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2007, Joachim Fenkes wrote:
> > The whole logic of dynamically adding and removing device is rather 
> bogus,
> > and it prevents autoloading of device drivers. of_platform_make_bus_id
> > is the function that is responsible for creating unique names over 
> there.
> 
> The plaintiff makes a valid point. How about a staging approach: We put 
> the patch as it is now into 2.6.23 so the problem is fixed, and I'll post 
> a "nice" version with autoloading support and a generic of_make_bus_id 
> function for 2.6.24. Agree?

Ok, sounds fair. Can you make sure that the resulting bus_id is the same
for the final version then?

	Arnd <><
