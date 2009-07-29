Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZG2N4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZG2N4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZG2N4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:56:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39730 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673AbZG2N4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:56:09 -0400
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090729111114.GA15239@redhat.com>
References: <20090729111114.GA15239@redhat.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 08:56:03 -0500
Message-Id: <1248875763.3900.1.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
> scsi/scsi.h is exported to userspace, so it should
> use __u8 instead of u8 as other userspace-visible headers do.

Actually, can we just put a hold on this until we decide what we're
doing with exporting include/scsi.

Arguments so far are

     1. Don't export and let glibc supply the headers (as it does now)
     2. Move headers to be exported to include/linux
     3. Take over include/scsi export from glibc: this will necessitate
        comparing our current headers and those of glibc and moving
        stuff around.

James


