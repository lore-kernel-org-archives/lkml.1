Return-Path: <linux-kernel-owner+w=401wt.eu-S1030814AbXDLWI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030814AbXDLWI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 18:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030797AbXDLWI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 18:08:27 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:60922 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030784AbXDLWI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 18:08:26 -0400
Subject: Re: [PATCH 1/1] cciss: kconfig patch to make cciss dependent on
	scsi for SG_IO ioctl
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       steve.cameron@hp.com
In-Reply-To: <20070412212741.GA10654@beardog.cca.cpqcorp.net>
References: <20070412212741.GA10654@beardog.cca.cpqcorp.net>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 17:07:15 -0500
Message-Id: <1176415635.3711.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-12 at 16:27 -0500, Mike Miller (OS Dev) wrote:
> This kconfig patch makes cciss dependent on scsi for the new SG_IO ioctl we just
> added. If cciss is built into the kernel it makes sures that scsi is also statically
> linked. If scsi is a module then cciss will also be built as a module. Please consider
> this for inclusion.

Erm, I don't think this is necessary: SG_IO is a property of the block
layer, not SCSI (as in it will work without SCSI even present).  SCSI
has a special driver: the sg driver that has its own implementation of
SG_IO, but that's the only connection.

James


