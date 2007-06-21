Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbXFUX7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbXFUX7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXFUX7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:59:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:62424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbXFUX7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:59:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: david@lang.hm
Subject: Re: Linux Kernel include files
Date: Fri, 22 Jun 2007 01:59:07 +0200
User-Agent: KMail/1.9.6
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <vapier.adi@gmail.com>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706220159.07948.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1957Eyk9fFwdqsY5DsKaBUeUlRL3whe09RtVIX
 CM9LEyAGA/d8I6GE9IswIDyL3F0IfMzL6gwBmKxGYpqp/NNPMt
 Zot5QLojZCvuSLYukcCPQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007, david@lang.hm wrote:
> this has been discussed many times and the answer is that the kernel is 
> not gong to change it's side of things to ANSI C.

I don't think that's entirely true with regard to the include files.
We have always tried not to step on anyone's toes there, e.g. regarding
the use of __u32 vs. uint32_t style types. It's certainly desirable
to make the kernel headers that are _meant_ for inclusion compatible
with standard compilers.

Mike Frysinger has posted a few patches that make the installed headers
friendlier to strict C99 users. While there was some negative feedback
about these patches, it was not about the idea of making the installed
headers C99 clean, but rather about the question whether those non-clean
parts should be exported in the first place.

Now whether a specific header file should be installed and potentially
included in user space is certainly debatable in many cases, but at
least it's now clearly defined through the include/*/Kbuild files.
If someone has a good reason to change which files are exported, he
should simply submit a patch against the list of exported files.

> that doesn't mean that one of the many projects out there to create 
> seperate interface headers won't do this.

Those projects are all practically dead, since we have the
'make headers_install' target in the Linux source.

	Arnd <><
