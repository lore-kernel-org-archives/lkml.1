Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXLEKcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXLEKcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXLEKbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:31:43 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:37888 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751472AbXLEKbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WFPNTy7gSzMN9ykh7Dst8bYTrIGV8D5KCNv6efnwmqss+ObSDvA78MmYOTlkanDDmI+Iib8Qhc+tF9LTVTvblpdIZ7QnPyFadtyGoUBcsYXxIoFOG1/KsdVOENETZeshRTf7zdCQ/pbuL+pbyEV1CPP9nnI5L+KfgrY22CRHVZQ=
Subject: Re: Kernel Development & Objective-C
From: Gilboa Davara <gilboad@gmail.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: LKML Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071204175046.GC2310@csclub.uwaterloo.ca>
References: <474EAD18.6040408@stellatravel.co.uk>
	 <20071130143445.GA2310@csclub.uwaterloo.ca>
	 <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
	 <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de>
	 <47539030.10600@argo.co.il>
	 <1196685331.3969.20.camel@gilboa-work-dev.localdomain>
	 <20071204175046.GC2310@csclub.uwaterloo.ca>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 12:31:34 +0200
Message-Id: <1196850694.23475.8.camel@gilboa-work-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-04 at 12:50 -0500, Lennart Sorensen wrote:
> On Mon, Dec 03, 2007 at 02:35:31PM +0200, Gilboa Davara wrote:
> > Intel's newest dual 10GbE NIC can easily (?) throw ~14M packets per
> > second. (theoretical peak at 1514bytes/frame)
> > Granted, installing such a device on a single CPU/single core machine is
> > absurd - but even on an 8 core machine (2 x Xeon 53xx/54xx / AMD
> > Barcelona) it can still generate ~1M packets/s per core.
> 
> 10GbE can't do 14M packets per second if the packets are 1514 bytes.  At
> 10M packets per second you have less than 1000 bits per packet, which is
> far from 1514bytes.
> 
> 10Gbps gives you at most 1.25GBps, which at 1514 bytes per packet works
> out to 825627 packets per second.  You could reach ~14M packets per
> second with only the smallest packet size, which is rather unusual for
> high throughput traffic, since you waste almost all the bytes on
> overhead in that case.  But you do want to be able to handle at least a
> million or two packets per second to do 10GbE.

... I corrected my math in the second email. [1] 

Never the less, a VOIP network (E.g. G729 and friends) can generate the
maximum number of frames allowed on 10GbE Ethernet which is, AFAIR just
below 15M -per- port. (~29M on a dual port card)

While I doubt that any non-NPU based NIC can handle such a load, on
mixed networks we're already seeing well-above 1M frames per port.

- Gilboa
[1] http://lkml.org/lkml/2007/12/3/69


