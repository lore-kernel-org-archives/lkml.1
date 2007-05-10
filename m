Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbXEJLGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbXEJLGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXEJLGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:06:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:49174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbXEJLGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:06:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] Allow compat_ioctl.c to compile without CONFIG_NET
Date: Thu, 10 May 2007 13:06:07 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
References: <20070510094110.GA16051@verge.net.au>
In-Reply-To: <20070510094110.GA16051@verge.net.au>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705101306.07956.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18sJQP3unc2dOTeJkdw5ZNqVneSIr/aEyQQOmW
 Ub0zjB9M325ac6w0V/seMURxQYoEdRJlWfwMwQQLmLHlf7N+nT
 cF3lh/SZsdXIWOMoThvcQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007, Simon Horman wrote:
> A small regression appears to have been introduced in the recent patch
> "cleanup compat ioctl handling", which was included in Linus' tree after
> 2.6.20.
> 
> siocdevprivate_ioctl() is no longer defined if CONFIG_NET is undefined,
> whereas previously it was a dummy function in this case.
> 
> This causes compilation with CONFIG_COMPAT but without CONFIG_NET to fail.
> 
> fs/compat_ioctl.c: In function `compat_sys_ioctl':
> fs/compat_ioctl.c:3571: warning: implicit declaration of function `siocdevprivate_ioctl'
> 
> Cc: Christoph Hellwig <hch@lst.de>
> From: Simon Horman <horms@verge.net.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
