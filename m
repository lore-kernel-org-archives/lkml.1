Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZHTPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZHTPNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbZHTPNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:13:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZHTPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:13:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv3 2/2] vhost_net: a kernel-level virtio server
Date: Thu, 20 Aug 2009 17:10:31 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
References: <cover.1250187913.git.mst@redhat.com> <200908201631.37285.arnd@arndb.de> <20090820144256.GB8338@redhat.com>
In-Reply-To: <20090820144256.GB8338@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201710.31723.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19CYz8MTpilGcdPf0zl1+gTV+58hNv2RY0D6Zr
 PKhPnrsmxKi5a94HTdohHHowEHsTK7mGnhYcMlLwOdiK/8H6Eu
 /Lqmi1uC80dHvFZuoZfIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Michael S. Tsirkin wrote:
> 
> > The errors from the socket (or chardev, as that was the
> > start of the argument) should still fit into the categories
> > that I mentioned, either they can be handled by the host
> > kernel, or they are fatal.
> 
> Hmm, are you sure? Imagine a device going away while socket is bound to
> it.  You get -ENXIO. It's not fatal in a sense that you can bind the
> socket to another device and go on, right?

Right. Not fatal in that sense, but fatal in the sense that I
can no longer transmit other frames until you recover. I think
we both meant the same here.

	Arnd <><
