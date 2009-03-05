Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZCENwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZCENwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbZCENwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:52:40 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:55098 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZCENwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:52:39 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] xen: core dom0 support
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 5 Mar 2009 14:52:31 +0100
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F42@exchange01.corp.win-professional.com>
In-Reply-To: <20090227212812.26d02f34.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] xen: core dom0 support
Thread-Index: AcmZZXi9HvbqfuJ0SUGr3l1qMzSWpgEMdhDA
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <George.Dunlap@eu.citrix.com>
X-OriginalArrivalTime: 05 Mar 2009 13:52:33.0753 (UTC) FILETIME=[A26F4C90:01C99D99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i think xen is a great virtualization technology.

Many company´s work with xen and the performance is better than KVM.

Here some benchmarks with Citrix XenServer 5.0 vs KVM with linux and windows guests on an IBM x3400 server:

HDD: XEN | KVM

Write: 110 MB/s | 60 MB/s
Read: 130 MB/s  | 80 MB/s

Network Performance: (download an 4 GB iso image from apache webserver)

XEN | KVM

download Speed: 105 MB/s | 50 MB/s

xen is using the full 1000 mbit network.. great performance!

On our IBM servers Xen is still faster than KVM.

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Andrew Morton
Sent: Saturday, February 28, 2009 6:28 AM
To: Jeremy Fitzhardinge
Cc: H. Peter Anvin; the arch/x86 maintainers; Linux Kernel Mailing List; Xen-devel
Subject: Re: [PATCH] xen: core dom0 support

On Fri, 27 Feb 2009 17:59:06 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This series implements the core parts of Xen dom0 support; that is, just
> enough to get the kernel started when booted by Xen as a dom0 kernel.

And what other patches can we expect to see to complete the xen dom0
support?


and..

I hate to be the one to say it, but we should sit down and work out
whether it is justifiable to merge any of this into Linux.  I think
it's still the case that the Xen technology is the "old" way and that
the world is moving off in the "new" direction, KVM?

In three years time, will we regret having merged this?
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
