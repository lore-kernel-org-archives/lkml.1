Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbXGOXUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbXGOXUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXGOXUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:20:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbXGOXUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:20:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Patches for REALLY TINY 386 kernels
Date: Mon, 16 Jul 2007 01:13:55 +0200
User-Agent: KMail/1.9.6
Cc: "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jonathan Campbell" <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
References: <469A8AED.7070207@nerdgrounds.com> <200707160912.55701.nigel@nigel.suspend2.net> <a781481a0707151614k57165061l464943233e9b32e8@mail.gmail.com>
In-Reply-To: <a781481a0707151614k57165061l464943233e9b32e8@mail.gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707160113.56110.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19YPhvyANCgJToOLlRUVhmECfvc9hMOrITikUd
 eyU1c+pksnHK6h/ecwP9uxHQ+eF5s1sEL7YvITqLncVkYjQvVy
 BT6ZtaHwa6AO01X4H5OCQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007, Satyam Sharma wrote:
> > Yeah. I was going for the general principle :)
> 
> Even simpler to add --exclude-from=.gitignore to diff
> 
Or build in a separate object directory, using the O=$my_objdir
Kbuild option. That has a number of addition advantages, e.g.
you can easily clean your object files using 'rm -rf $my_objdir'
and if you grep -r the source, you don't find your search string
in generated files.

	Arnd <><
