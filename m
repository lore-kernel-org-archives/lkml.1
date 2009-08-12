Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZHLNrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZHLNrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 09:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZHLNrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 09:47:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZHLNrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 09:47:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv2 0/2] vhost: a kernel-level virtio server
Date: Wed, 12 Aug 2009 15:40:44 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: Gregory Haskins <gregory.haskins@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Patrick Mullaney <pmullaney@novell.com>
References: <20090811212743.GA26309@redhat.com> <200908121452.01802.arnd@arndb.de> <20090812130612.GC29200@redhat.com>
In-Reply-To: <20090812130612.GC29200@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908121540.44928.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/JRs+BJXxMLF4iIxXFMCqv+JCuEraKs+MM5gW
 V4dh9t3j5KjGvR8ql+MUBOUE+6RHpUsNeYHVNb8JVu4VoDg6+X
 XlsDXiAlI04E4huJblNTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Michael S. Tsirkin wrote:
> > If I understand it correctly, you can at least connect a veth pair
> > to a bridge, right? Something like
> > 
> >            veth0 - veth1 - vhost - guest 1 
> > eth0 - br0-|
> >            veth2 - veth3 - vhost - guest 2
> >            
> Heh, you don't need a bridge in this picture:
> 
> guest 1 - vhost - veth0 - veth1 - vhost guest 2

Sure, but the setup I described is the one that I would expect
to see in practice because it gives you external connectivity.

Measuring two guests communicating over a veth pair is
interesting for finding the bottlenecks, but of little
practical relevance.

	Arnd <><
