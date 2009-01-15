Return-Path: <linux-kernel-owner+w=401wt.eu-S1761811AbZAOVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761811AbZAOVYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbZAOVXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:23:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbZAOVXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:23:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Date: Thu, 15 Jan 2009 22:22:53 +0100
User-Agent: KMail/1.9.9
Cc: Ira Snyder <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, David Miller <davem@davemloft.net>,
       "Jan-Bernd Themann" <themann@de.ibm.com>
References: <20090107195052.GA24981@ovro.caltech.edu> <200901151853.52202.arnd@arndb.de> <20090115192129.GB9091@ovro.caltech.edu>
In-Reply-To: <20090115192129.GB9091@ovro.caltech.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901152222.55006.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19h8vEOPNJPE3euO0rk+8+EL4hwn6XNIchSkbX
 jvrSZqLI3rQYZ++J4xMhIvzKf0h13u+WgxhAgPVsOX6OAEv1Pb
 kBD2BV1YcxrvY59FcRNZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Ira Snyder wrote:
> I have another question for you Arnd.
> 
> What did you use as the host and guest drivers when you ran virtio over
> PCI? Did you use two unmodified instances of virtio_net (one on host,
> one on guest) for networking, or did you write new virtio drivers for
> those? How about for virtio_console (if you ran it at all).

Jan-Bernd may be able to tell you details about this, and send you the
driver code that his interns implemented for it.
This was only doing virtio_net between two machines using MMIO transfers,
i.e. the DMA engine was unused, but there was a mailbox interrupt (if you
have one of these, you won't need MSI, btw -- just write a DMA to it).

	Arnd <><
