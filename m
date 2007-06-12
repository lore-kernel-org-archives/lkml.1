Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbXFLARp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbXFLARp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXFLARi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:17:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbXFLARh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:17:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: ext2 on flash memory
Date: Tue, 12 Jun 2007 02:17:24 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, maxdamage@aladin.ro
References: <466D379C.6000809@wpkg.org>
In-Reply-To: <466D379C.6000809@wpkg.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120217.24546.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+U3DX3KAlPDbsrAlsNQzJKzQH0eA0rtFz6I0d
 KQoxcgworNl9JpPlZIKto19P9VC6ru04qugJJpphVp76VhCoYX
 32le77fzmsjsn9dL2pmSA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2007, Tomasz Chmielewski wrote:
> Also, ext2 provides a nice feature other filesystems lack: xip. 
> Especially, if a pendrive is used as a rootfs for a small device.

Well, xip cannot work on NAND flash media, including USB pen drives,
because the data is not mapped into the addressable memory space,
so that is not really an interesting argument.

	Arnd <><
