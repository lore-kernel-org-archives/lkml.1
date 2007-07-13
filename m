Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbXGMKIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbXGMKIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 06:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbXGMKIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 06:08:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbXGMKIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 06:08:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [patch 0/4] Cell SPE logos
Date: Fri, 13 Jul 2007 12:05:19 +0200
User-Agent: KMail/1.9.6
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@infradead.org>
References: <20070710122702.765654000@pademelon.sonytel.be> <20070712160621.644d78d2.akpm@linux-foundation.org> <Pine.LNX.4.62.0707131051190.18802@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0707131051190.18802@pademelon.sonytel.be>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707131205.20399.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+vIkn2H9ZrgrqM5+ICeA+mY9wno+TsmLj2knI
 1DqXKWG0wS5YAlLTbT1AC4+SA9tJ8ENndsNWcubEX+/EmATFFw
 YasodA8rqqfKkNVUxmSsg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007, Geert Uytterhoeven wrote:
> > > Summaries:
> > >   [1] fbdev: extract fb_show_logo_line()
> > >   [2] fbdev: Add fb_append_extra_logo()
> > 
> > This one does give additional code and data to all fbdev users while only
> > being useful to cell machines.  Should we fix that?
> 
> I can protect it by #ifdef CONFIG_PPC_CELL (as long as there are no other
> users). Would that be OK?

If you want to have an #ifdef in there, it should probably be
CONFIG_FB_EXTRA_LOGO and have that autoselected by CONFIG_SPU_BASE.

A nicer alternative to the #ifdef might be to mark it __init, so
that it will just go away after boot. Not sure if that's safe
though.

	Arnd <><
