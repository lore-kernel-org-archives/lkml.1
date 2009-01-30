Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbZA3Bpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbZA3Bpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZA3Bps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:45:48 -0500
Received: from ozlabs.org ([203.10.76.45]:50629 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZA3Bpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:45:47 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH] virtio-pci: do not oops on config change if driver not loaded
Date: Fri, 30 Jan 2009 12:15:40 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
References: <1233243136-8028-1-git-send-email-markmc@redhat.com>
In-Reply-To: <1233243136-8028-1-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301215.40312.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 02:02:16 Mark McLoughlin wrote:
> The host really shouldn't be notifying us of config changes
> before the device status is VIRTIO_CONFIG_S_DRIVER or
> VIRTIO_CONFIG_S_DRIVER_OK.
> 
> However, if we do happen to be interrupted while we're not
> attached to a driver, we really shouldn't oops.

Thanks, applied!

Rusty.
