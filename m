Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXE3Vue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXE3Vue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbXE3VtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:49:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51431 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760859AbXE3VtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:49:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Wedgwood <cw@f00f.org>
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Date: Wed, 30 May 2007 23:48:53 +0200
User-Agent: KMail/1.9.6
Cc: Michal Marek <mmarek@suse.cz>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz> <20070530170530.GA4197@tuatara.stupidest.org>
In-Reply-To: <20070530170530.GA4197@tuatara.stupidest.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705302348.54259.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18LiNsCkpbVE1/CP2zcJ0EUExEA8iG02Fm1wzs
 de6uNuFZOz21y391AD1MXyinJTz8tvflD2FRzkFa5oP8yru6OZ
 ZOaqp/3cyeHll2P6uUjoQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007, Chris Wedgwood wrote:
> 
> On Wed, May 30, 2007 at 02:59:55PM +0200, Michal Marek wrote:
> 
> > +typedef struct xfs_fsop_geom_v132 {
> 
> wouldn't xfs_fsop_geom_v1_32
>                          ^
> 
> > +     __u32           blocksize;      /* filesystem (data) block size */
> 
> [...]
> 
> > +     __u32           dirblocksize;   /* directory block size, bytes  */
> > +} __attribute__((packed)) xfs_fsop_geom_v132_t;
> 
> and xfs_fsop_geom_v1_32_t
>                     ^
> 
> read better there?

Actually, the current convention would be struct compat_xfs_fsop_geom_v1
and compat_xfs_fsop_geom_v1_t.

	Arnd <><
