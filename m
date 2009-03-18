Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbZCRWrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbZCRWrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZCRWrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:47:23 -0400
Received: from ozlabs.org ([203.10.76.45]:35172 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbZCRWrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:47:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: VIRTIO_BLK_T_SCSI_CMD handling in virtio-blk
Date: Thu, 19 Mar 2009 09:17:14 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20090318060919.GA21777@infradead.org>
In-Reply-To: <20090318060919.GA21777@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903190917.14780.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009 16:39:19 Christoph Hellwig wrote:
> All backends that I checked just fail VIRTIO_BLK_T_SCSI_CMD commands, so
> AFAICS no harm is done.  But should we really keep this broken support
> in the protocol around?  If we do want to support packet commands in
> the future we should probably just add the command as the first S/G list
> entry.

It was pretty much a placeholder for "eject".  Feel free to be the one to
define it.

But note that we chose not to use sg boundaries as part of the protocol, so
if there's going to be more than one entry, you'll need some metadata.

> Is there an actual protocol spec for virtio-blk somewhere to write these
> subtilities down?  Or an list of implementations to check at least?

No, but I look forward to reading your spec :)

Thanks!
Rusty.
