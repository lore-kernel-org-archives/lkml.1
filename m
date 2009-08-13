Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZHMNtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZHMNtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 09:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZHMNtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 09:49:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbZHMNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:49:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Date: Thu, 13 Aug 2009 15:48:35 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
References: <cover.1249930169.git.mst@redhat.com> <20090813060615.GC3029@redhat.com> <200908131538.44465.arnd@arndb.de>
In-Reply-To: <200908131538.44465.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908131548.35199.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+eZLTYg27rt8QREoMs9vJmlQuNgoKKcxTqxcB
 jEkRFetM3yq9RSrepBjyNsS5ycPoUdDHbOwiaj1X4dp/lW58Oy
 169wQMuSY8D1SEYiA/HmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Arnd Bergmann wrote:
> Unfortunately, this also implies that you could no longer simply use the
> packet socket interface as you do currently, as I realized only now.
> This obviously has a significant impact on your user space interface.

Also, if we do the copy in the transport, it definitely means that we
can't get to zero-copy RX/TX from guest space any more. The current
vhost_net driver doesn't do that yet, but could be extended in the
same way that I'm hoping to do it for macvtap.

	Arnd <><
