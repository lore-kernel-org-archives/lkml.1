Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbXKGGJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbXKGGJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbXKGGJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:09:19 -0500
Received: from ozlabs.org ([203.10.76.45]:35704 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419AbXKGGJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:09:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: Use of virtio device IDs
Date: Wed, 7 Nov 2007 17:09:46 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Anthony Liguori <aliguori@us.ibm.com>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <4730A15A.6070001@us.ibm.com> <4731334A.6090405@gmail.com> <47314FBD.1070505@qumranet.com>
In-Reply-To: <47314FBD.1070505@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711071709.47192.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 16:40:13 Avi Kivity wrote:
> Gregory Haskins wrote:
> >  but FWIW: This is a major motivation for the reason that the
> > IOQ stuff I posted a while back used strings for device identification
> > instead of a fixed length, centrally managed namespace like PCI
> > vendor/dev-id.  Then you can just name your device something reasonably
> > unique (e.g. "qumranet::veth", or "ibm-pvirt-clock").
>
> I dislike strings.  They make it look as if you have a nice extensible
> interface, where in reality you have a poorly documented interface which
> leads to poor interoperability.

Yes, you end up with exactly names like "qumranet::veth" 
and "ibm-pvirt-clock".  I would recommend looking very hard at /proc, Open 
Firmware on a modern system, or the Xen store, to see what a lack of 
limitation can do to you :)

> We will support non-pci for s390, but in order to support Windows and
> older Linux PCI is necessary.

The aim is that PCI support is clean, but that we're not really tied to PCI.  
I think we're getting closer with the recent config changes.

Cheers,
Rusty.
