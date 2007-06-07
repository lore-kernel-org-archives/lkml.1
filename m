Return-Path: <linux-kernel-owner+w=401wt.eu-S965842AbXFGAam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965842AbXFGAam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764308AbXFGAaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:30:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:63438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbXFGAae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:30:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Date: Thu, 7 Jun 2007 02:29:56 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
In-Reply-To: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706070229.57473.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+FctEUcoRcGspJ/JjQKCvVqVoDYtAF52m2AaK
 Iy/aXF4L1sJH7PtvSJL9XHe6X860iuMTy9EMpdm30R3BWsiXU7
 ZKPYk/Kd0gSe3FeEcNOlg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007, Davide Libenzi wrote:
> The sys_socketcall() system call has been also changed to support
> a new SYS_SOCKET2 indentifier.

I thought the general agreement was that sys_socketcall is a bad
idea to start with. Is there any benefit in adding new calls to
it instead of using a new system call number for sys_socket2 on
all architectures?

	Arnd <><
