Return-Path: <linux-kernel-owner+w=401wt.eu-S1423460AbXDZAdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423460AbXDZAdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423454AbXDZAdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:33:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423456AbXDZAdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
Date: Thu, 26 Apr 2007 02:32:06 +0200
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, maxextreme@gmail.com, gregkh@suse.de
References: <20070423141123.GA21174@skybase> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org>
In-Reply-To: <20070425172447.1576c399.akpm@linux-foundation.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704260232.06909.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/bBPzGLdLF59qaGuxhvcqUBQzBWNyPPlr0wXF
 umNH2rSwlF5rWd8ZiMzxZChMF16zonWa2DEWNsYQkhf6xJs9vZ
 lKrYmHNMUbKYUcYd4QmQw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007, Andrew Morton wrote:
> It would be neat if someone could create and maintain a new
> scripts/spot-common-mistakes.  Feed it a unified diff and it would complain
> about newly-added code (and only newly-added code) which has busted
> whitespace, adds new semaphores, adds new kernel_thread calls, etc, etc.

http://patchstylecheck.googlecode.com/svn/trunk/patchstylecheckemail.pl
Might serve as a starting point for this. It doesn't have any semantic
checks right now, but I guess they can be added.

	Arnd <><
