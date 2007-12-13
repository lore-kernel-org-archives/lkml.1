Return-Path: <linux-kernel-owner+w=401wt.eu-S1764677AbXLMSrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764677AbXLMSrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbXLMSrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:47:20 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:8657 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753288AbXLMSrT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:47:19 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 32/36] XFS: Make xfsbufd threads freezable
Date: Thu, 13 Dec 2007 13:46:55 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B001520239@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20071213063529.GG25301@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 32/36] XFS: Make xfsbufd threads freezable
Thread-Index: Acg9VD8EcIQ0eodmTK28GEmBIgDYyQAZBmQQ
References: <20071213062511.265908583@mini.kroah.org> <20071213063529.GG25301@kroah.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Greg KH" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>
Cc: "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "David Chinner" <dgc@sgi.com>,
       "Lachlan McIlroy" <lachlan@sgi.com>,
       "Oliver Pintr" <oliver.pntr@gmail.com>
X-OriginalArrivalTime: 13 Dec 2007 18:46:56.0821 (UTC) FILETIME=[89619650:01C83DB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de Greg KH
> Envoyé : 13 décembre 2007 01:35
> 
> 2.6.22-stable review patch.  If anyone has any objections, 
> please let us know.
> 
> ------------------
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> patch 978c7b2ff49597ab76ff7529a933bd366941ac25 in mainline
> 
> Fix breakage caused by commit 831441862956fffa17b9801db37e6ea1650b0f69
> that did not introduce the necessary call to set_freezable() 
> in xfs/linux-2.6/xfs_buf.c .
> 
> SGI-PV: 974224
> SGI-Modid: xfs-linux-melb:xfs-kern:30203a
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: David Chinner <dgc@sgi.com>
> Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> Cc: Oliver Pintr <oliver.pntr@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---

Hi Greg,

Don't know if it is related but I got this while building on Debian Etch 4.0:
  Building modules, stage 2.
  MODPOST 1882 modules
ERROR: "set_freezable" [fs/xfs/xfs.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.22.15-rc1-cfs-etch-686-envcan'
make: *** [debian/stamp-build-kernel] Error 2

- vin
