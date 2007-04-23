Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbXDWNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbXDWNyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXDWNyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:54:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:63982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbXDWNyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:54:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH/RESEND] ehea: fix for dlpar and sysfs entries
Date: Mon, 23 Apr 2007 15:54:04 +0200
User-Agent: KMail/1.9.6
Cc: Jan-Bernd Themann <ossthema@de.ibm.com>, Jeff Garzik <jeff@garzik.org>,
       Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200704231358.53479.ossthema@de.ibm.com>
In-Reply-To: <200704231358.53479.ossthema@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704231554.06110.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19/egdNOJgwyfrl2ytBX6tygMnis6T54kDKLDu
 1D7dcsbv5Drp4r5tznI+LbcdIcPgv0RMo6cscC+3cYjohBig0q
 1vyfGT5vxr7kL+/KEgGhQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007, Jan-Bernd Themann wrote:
> - dlpar fix: 
>         certain resources may only be allocated when first
>         logical port is available, and must be removed when
>         last logical port has been removed
> 
> - sysfs entries:
>         create symbolic link from each logical port to ehea driver
> 

I can't see anything wrong with the patch contents, but if you know that there
are two changes, you really should make it two separate patches.

	Arnd <><
