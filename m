Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbXLDRuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbXLDRuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXLDRur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:50:47 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:51028 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbXLDRur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:50:47 -0500
Date: Tue, 4 Dec 2007 12:50:46 -0500
To: Gilboa Davara <gilboad@gmail.com>
Cc: LKML Linux Kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@argo.co.il>
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071204175046.GC2310@csclub.uwaterloo.ca>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com> <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de> <47539030.10600@argo.co.il> <1196685331.3969.20.camel@gilboa-work-dev.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196685331.3969.20.camel@gilboa-work-dev.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 02:35:31PM +0200, Gilboa Davara wrote:
> Intel's newest dual 10GbE NIC can easily (?) throw ~14M packets per
> second. (theoretical peak at 1514bytes/frame)
> Granted, installing such a device on a single CPU/single core machine is
> absurd - but even on an 8 core machine (2 x Xeon 53xx/54xx / AMD
> Barcelona) it can still generate ~1M packets/s per core.

10GbE can't do 14M packets per second if the packets are 1514 bytes.  At
10M packets per second you have less than 1000 bits per packet, which is
far from 1514bytes.

10Gbps gives you at most 1.25GBps, which at 1514 bytes per packet works
out to 825627 packets per second.  You could reach ~14M packets per
second with only the smallest packet size, which is rather unusual for
high throughput traffic, since you waste almost all the bytes on
overhead in that case.  But you do want to be able to handle at least a
million or two packets per second to do 10GbE.

--
Len Sorensen
