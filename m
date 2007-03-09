Return-Path: <linux-kernel-owner+w=401wt.eu-S2992831AbXCIPLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992831AbXCIPLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992829AbXCIPLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:11:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:51121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992831AbXCIPL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:11:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 7/7] revoke: wire up s390 system calls
Date: Fri, 9 Mar 2007 16:11:09 +0100
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
References: <Pine.LNX.4.64.0703091016340.32320@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703091016340.32320@sbz-30.cs.Helsinki.FI>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091611.09737.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/P0FzaGmiQSswjV22iwFjp926TrMtMW6i63fT
 xL40zB13ksFIn6iNKROG66rucPRcCjOzw+T8D0zn5ib9fw1rIb
 k5rCgsEvxY4M1vtEBjfWA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007, Pekka J Enberg wrote:
> 
> From: Serge E. Hallyn <serue@us.ibm.com>
> 
> Make revokeat and frevoke system calls available to user-space on s390.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Looks good to me, but you really should through Martin, since he
has an overview of what syscall numbers may already be assigned
some another patch he has queued up.

	Arnd <><
