Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYCTFrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYCTFrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 01:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYCTFrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 01:47:36 -0400
Received: from ozlabs.org ([203.10.76.45]:35164 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYCTFrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 01:47:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] virtio_pci: unregister virtio device at device remove
Date: Thu, 20 Mar 2008 16:46:44 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: virtualization@lists.linux-foundation.org,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <1205976904-19592-1-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <1205976904-19592-1-git-send-email-aliguori@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803201646.45006.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2008 12:35:04 Anthony Liguori wrote:
> Make sure to call unregister_virtio_device() when a virtio device is
> removed. Otherwise, virtio_pci.ko cannot be rmmod'd.
>
> This was spotted by Marcelo Tosatti.
>
> Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

Thanks, applied.

Rusty.
