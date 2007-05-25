Return-Path: <linux-kernel-owner+w=401wt.eu-S1765571AbXEYVFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765571AbXEYVFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXEYVFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:05:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51109 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbXEYVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:05:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Date: Fri, 25 May 2007 23:04:29 +0200
User-Agent: KMail/1.9.6
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
References: <20070525083607.784351000@sonycom.com> <200705251850.30342.arnd@arndb.de> <Pine.LNX.4.62.0705252135010.2657@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0705252135010.2657@pademelon.sonytel.be>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705252304.30396.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/hg6QsfTa+HyBXR3Siw4dGV9hZIQLsMoRzMAb
 iDKZOoplkjR56NuV82fRTXBVykkN5WgD9vcsU+TFctDxH1/BAz
 xd8OX99F/Fojh9x19wWtw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007, Geert Uytterhoeven wrote:
> 
> > What is the problem? Is there infrastructure missing in the
> > CD-ROM layer?
> 
> As the CD/DVD/BD part just accepts SCSI/ATAPI commands (except for plain
> read/write), I was suggested to keep it as a SCSI driver.

Ok, so I guess the tradeoff here is that by writing it as a SCSI
driver, you don't need to implement any of the cdrom_device_ops
yourself but instead need to fake a few of the SCSI commands
in ps3rom_request(). Fair enough.

	Arnd <><
