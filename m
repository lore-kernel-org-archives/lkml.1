Return-Path: <linux-kernel-owner+w=401wt.eu-S1765321AbXEYUoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765321AbXEYUoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXEYUnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:43:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbXEYUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:43:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
Date: Fri, 25 May 2007 22:43:41 +0200
User-Agent: KMail/1.9.6
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
References: <20070525083607.784351000@sonycom.com> <200705251826.25572.arnd@arndb.de> <Pine.LNX.4.62.0705252137230.2657@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0705252137230.2657@pademelon.sonytel.be>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705252243.41508.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX192kaYfKLCGtTKG+77Hv4S1Pr8wqFbXpHontJK
 BQS1IL6DUA7qJRFnTyHGtsZXe8rnMNqHEj6VTN1Dj8CS6NABle
 dnZEK+5s4Yyr322SUp+TA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007, Geert Uytterhoeven wrote:
> 
> > I don't really understand what the kthread is needed for. You probably
> > thought about multiple options and ended up with this, but having
> > a comment in front of it might be helpful.
> 
> I used a kthread because the request function of a block device driver must be
> non-blocking, and ps3stor_read_write_sectors() calls wait_for_completion().

Ok, but why does it call wait_for_completion() then?
I thought you could end_that_request_* from the interrupt handler instead.

	Arnd <><
