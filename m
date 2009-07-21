Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZGUWFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZGUWFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZGUWFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:05:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbZGUWFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:05:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Do cpu-endian MMIO accessors exist?
Date: Wed, 22 Jul 2009 00:05:27 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <200907212315.50225.arnd@arndb.de> <4A663987.4040500@gmail.com>
In-Reply-To: <4A663987.4040500@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907220005.27583.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Do87nAEsyALZB2k/kguxRJbaKbWdROfMGeg3
 +PAPeLmHq7bW0fhpuedplEUskwAG5IiOHRbBTJWKYQft0cTMOK
 6eUkmEzAmI84Mby5ClHsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Jiri Slaby wrote:
> On 07/21/2009 11:15 PM, Arnd Bergmann wrote:
> > __raw_readl is not a replacement for real accessors like
> > ioread32 or in_be32, because it does not synchronize with the
> > instruction stream.
> 
> Aha, I see now. I guess it's a bug that ioread/write* on sh are not with
> barriers?

That depends on how that architecture defines its bus interface.
On many simple architectures, you do not need any synchronization
operations.

	Arnd <><
