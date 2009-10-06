Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbZJFX1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbZJFX1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933418AbZJFX1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:27:32 -0400
Received: from ozlabs.org ([203.10.76.45]:54233 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396AbZJFX1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:27:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: john cooper <john.cooper@redhat.com>
Subject: Re: [PATCH 1/4] virtio_blk: deprecate the 1024-byte ID field.
Date: Tue, 6 Oct 2009 19:51:46 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <200909300248.09630.rusty@rustcorp.com.au> <200909300941.24736.borntraeger@de.ibm.com> <4ACA1CBC.8020402@redhat.com>
In-Reply-To: <4ACA1CBC.8020402@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061951.47231.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 02:50:12 am john cooper wrote:
> It seems simply retiring use of the VIRTIO_BLK_F_IDENTIFY
> binary value should be sufficient.  The patch which
> implemented the cooperating logic in qemu was dropped
> due to the config space issue.

OK, I'll just remove it then.

Also, I've been convinced to just hand over the 20 byte serial number
since we're revisiting this.  It's simple, and there's no clear consensus.

Thanks,
Rusty.
