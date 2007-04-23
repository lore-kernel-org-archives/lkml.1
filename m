Return-Path: <linux-kernel-owner+w=401wt.eu-S1161461AbXDWLt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161461AbXDWLt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161497AbXDWLt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:49:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:56115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161467AbXDWLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:49:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: schwidefsky@de.ibm.com
Subject: Re: [PATCH 7/8] Kconfig: silicon backplane dependency.
Date: Mon, 23 Apr 2007 13:48:05 +0200
User-Agent: KMail/1.9.6
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
References: <20070420113505.GH3738@skybase> <200704231322.36970.arnd@arndb.de> <1177327676.5984.12.camel@localhost>
In-Reply-To: <1177327676.5984.12.camel@localhost>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231348.06148.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18SSDzsDrZu9dhhrbxd4OJOhUo1VT0caXe3h2U
 gTJmjlrXVqhTnlEyc59gqScar1s7kwOszDsXdsFk3pysdHwdZD
 JyXR+4cjjwyolzvLNQ0pA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007, Martin Schwidefsky wrote:
> 
> > Isn't B44 already behind a WIRELESS or IEEE80211 or similar option that
> > can't be selected on s390?
> 
> No, the option can be found in drivers/net/Kconfig under menu "Ethernet
> (10 or 100Mbit)".

Ah, I was confusing it with b43.

Depends on HAS_IOMEM sounds good then. I'd prefer to make it
'depends on SSB' instead of 'select SSB', but I don't want to get into
that argument ;-)

	Arnd <><
