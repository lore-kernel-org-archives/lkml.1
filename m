Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760AbZG3JfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbZG3JfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZG3JfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:35:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46413 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZG3JfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:35:21 -0400
Date: Thu, 30 Jul 2009 12:34:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Message-ID: <20090730093403.GA11381@redhat.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <20090729162844.GA22561@merkur.ravnborg.org> <1248885456.3900.48.camel@mulgrave.site> <4A7166A3.70509@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7166A3.70509@panasas.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 12:23:47PM +0300, Boaz Harrosh wrote:
> >> I did a quick diff of the glibc provided scsi.h and kernel scsi.h.
> >> >From a quick look it seems that we have more in the kernel version
> >> than the glibc version - and no obvious conflicts.
> >>
> 
> exactly it is original Kernel headers from the time they where sampled
> last by glibc.

glibc also added
#include <features.h>
in some of them.
Donnu why.

