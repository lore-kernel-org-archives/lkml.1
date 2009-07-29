Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbZG2VMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbZG2VMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZG2VMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:12:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56396 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbZG2VMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:12:43 -0400
Date: Thu, 30 Jul 2009 00:11:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Message-ID: <20090729211140.GB3592@redhat.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248875763.3900.1.camel@mulgrave.site>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 08:56:03AM -0500, James Bottomley wrote:
>      3. Take over include/scsi export from glibc: this will necessitate
>         comparing our current headers and those of glibc and moving
>         stuff around.

Speaking of which: is there a chance some userspace still depends on
SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} being defined (even though they don't
work) ? glibc headers have them ...
