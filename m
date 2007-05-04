Return-Path: <linux-kernel-owner+w=401wt.eu-S1767485AbXEDACK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767485AbXEDACK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767486AbXEDACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:02:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57454 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767485AbXEDACJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:02:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Date: Fri, 4 May 2007 02:01:56 +0200
User-Agent: KMail/1.9.6
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <20070503235747.29275.37271.stgit@localhost.localdomain>
In-Reply-To: <20070503235747.29275.37271.stgit@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705040201.57284.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/4AY98TaInIhbZ2xPRRHVh5BvlzeaVNQ11DO4
 QFQpQvpUb1xTqqFmOXRyPuYZVgTZOkHBMBZ/WRXrBpPaKiXWTs
 g2HwvReWqDd3KJvqzbrZA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007, Vitaly Bordug wrote:
> Adds support for PowerQuicc on-chip PCMCIA. The driver is implemented as
> of_device, so only arch/powerpc stuff is capable to use it, which now
> implies only mpc885ads reference board.
> 
> To cope with the code that should be hooked inside driver, but is really
> board specific (like set_voltage), global structure mpc8xx_pcmcia_ops
> holds necessary function pointers that are filled in the BSP code.
> 
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
