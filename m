Return-Path: <linux-kernel-owner+w=401wt.eu-S937581AbXHHVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937581AbXHHVLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763806AbXHHVLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:11:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51760 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763241AbXHHVLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:11:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: ljhc@br.ibm.com
Subject: Re: SLUB doesn't work with kdump kernel on Cell
Date: Wed, 8 Aug 2007 23:10:59 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Arnd Bergmann <arndb@arndb.de>
References: <1186604151.3608.46.camel@localhost.localdomain>
In-Reply-To: <1186604151.3608.46.camel@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708082310.59997.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/W8comqJNYvyTpRbAoJMcXPgVi3/75aK+xET3
 BANSCV0Hib9xJ2WAtdKvhLuYRF4spDGp9XwHJoPeaw0L+VHXH7
 I+d0iFWtIClhnOEArxHnA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007, Lucio Correia wrote:
>   DMA             0 ->    12288
>   Normal      12288 ->    12288
> early_node_map[2] active PFN ranges
>     0:        0 ->     2560
>     1:    12287 ->    12288

As Christoph found, this memory map is really strange. Other machines
have something like

Zone PFN ranges:
  DMA             0 ->    16384
  Normal      16384 ->    16384
early_node_map[2] active PFN ranges
    0:        0 ->     8192
    1:     8192 ->    16384

Lucio,
What code builds the memory map that gets passed to the kdump kernel?
Does the original kernel see the same map on your machine?

	Arnd <><
