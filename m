Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbXDVVtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbXDVVtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 17:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXDVVtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 17:49:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:53768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXDVVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 17:49:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: Fw: [PATCH][RFC] PCMCIA support for 8xx using platform devices
Date: Sun, 22 Apr 2007 23:49:41 +0200
User-Agent: KMail/1.9.6
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-pcmcia@lists.infradead.org,
       lkml <linux-kernel@vger.kernel.org>
References: <20070422232658.5f427fd3@localhost.localdomain>
In-Reply-To: <20070422232658.5f427fd3@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704222349.42368.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18IDspJZvejHVsoo0d29IYojPn6cPi/zepJoLg
 bS63pC4bGx1vXJOkb3ES9+wUdFZi9J5fgGtm63Rst4MwxPKprW
 pZInNp09PhAST16cMu7dQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007, Vitaly Bordug wrote:
> This utilizes PCMCIA on mpc885ads and mpc866ads from arch/powerpc. In the
> new approach, direct IMMR accesses from within drivers/ were totally
> eliminated, that requires hardware_enable, hardware_disable, voltage_set
> board-specific functions to be moved over to BSP code section   
> (arch/powerpc/platforms/8xx in 885 case). There is just no way to have
> both arch/ppc and arch/powerpc approaches to work simultaneously because
> of that.  

Maybe I'm missing a key issue here, but what's the point of adding
more platform_devices for stuff that is already in the device tree?
Shouldn't this be made an of_platform_driver instead so you can
use the existing of_device directly?

	Arnd <><
