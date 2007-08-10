Return-Path: <linux-kernel-owner+w=401wt.eu-S935885AbXHJRn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935885AbXHJRn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXHJRns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:43:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbXHJRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:43:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] SLUB doesn't work with kdump kernel on Cell
Date: Fri, 10 Aug 2007 17:43:33 +0200
User-Agent: KMail/1.9.6
Cc: "Michael Ellerman" <michael@ellerman.id.au>, ljhc@br.ibm.com,
       Arnd Bergmann <arndb@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain> <1186667828.3038.18.camel@localhost.localdomain> <dc1166600708091734p22612a72g7fcc3e229203918f@mail.gmail.com>
In-Reply-To: <dc1166600708091734p22612a72g7fcc3e229203918f@mail.gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708101743.34988.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19dKJr9ykzvbuO2Xn+4sUvw4rEM76xsa55I6Ku
 WfmzMqkBcayoSMGX9fqBh6teOtgkAs9RRpa9Xj2jfPAUIuCnJs
 F5YS/ZuX6ofenaTWeoslg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2007, Michael Ellerman wrote:
> It comes out of the device tree, just like a regular kernel. The
> device tree for the kdump kernel is built by kexec-tools, it parses
> /proc/device-tree and does a bunch of logic to avoid various reserved
> regions: the kernel, TCE tables, RTAS etc.

Maybe it should then try to flatten out the NUMA properties and put
all pages logically into the same node that the boot CPU resides on.
I can see a number of things going wrong otherwise.

	Arnd <><
