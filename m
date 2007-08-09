Return-Path: <linux-kernel-owner+w=401wt.eu-S966757AbXHIRKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966757AbXHIRKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934268AbXHIRKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:10:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890AbXHIRKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:10:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Thu, 9 Aug 2007 17:30:16 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
References: <20070809131423.GA9927@shell.boston.redhat.com> <200708091441.28511.arnd@arndb.de> <46BB24CB.1040405@redhat.com>
In-Reply-To: <46BB24CB.1040405@redhat.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091730.19024.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Q1VB0bDVGM2wcIceumY9+3fBfhH/KIqH/Ylm
 R0oMxpRr9BiriBjDj8k9lA2XsLpwA2aGBx/wsxI9wHAUX4jQWf
 4PAwN7R6RuYtDgtbJUuIw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007, Chris Snook wrote:
> a) chicken and egg: asm-generic/atomic.h depends on definitions in asm/atomic.h

Ok, I see.
 
> If you can find a way to reshuffle the code and make it simpler, I personally am 
> all for it. I'm skeptical that you'll get much to show for the effort. 

I guess it could  be done using more macros or new headers, but I don't see
a way that would actually improve the situation.

> b) The definitions aren't precisely identical between all architectures, so it 
> would be a mess of special cases, which gets us right back to where we are now.

Why are they not identical? Anything beyond the 32/64 bit difference should
be the same afaics, or it might cause more bugs.

	Arnd <><
