Return-Path: <linux-kernel-owner+w=401wt.eu-S1764119AbXGJWF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764119AbXGJWF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 18:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761324AbXGJWFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 18:05:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbXGJWFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 18:05:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: avoiding rejects
Date: Wed, 11 Jul 2007 00:03:48 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070710124422.a52b0458.akpm@linux-foundation.org> <Pine.LNX.4.64.0707102306030.10340@anakin>
In-Reply-To: <Pine.LNX.4.64.0707102306030.10340@anakin>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707110003.49287.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19wRMI3Es2yyNsOvz41WzFPGLwxrovpfUhKv97
 hpIhmC3h8lr36eXHl3AaWE6WUqwzykIIExWgDeUeBBJ8RYtQ8Q
 KpN5JtOn5USvoDek8pkqw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007, Geert Uytterhoeven wrote:
> 
> > Most of these lists are unordered anyway, so inserting the new item at a
> > randomly-chosen position is a better approach than just appending it.
> 
> Really?
> 
> #includes should be sorted alphabetically
> Lots of other stuff should be sorted numerically/alphabetically
> 

I would also argue that adding in an ordered way is better than
at random positions, that is if the list is ordered to start with.
As long as everyone follows the same order, you will get (desired)
conflicts in case two people try to add the same line, and when
the added lines are different, it's as good as random ordering
to avoid undesired merge conflicts.

	Arnd <><
