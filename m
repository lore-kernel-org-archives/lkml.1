Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZKWCBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZKWCBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZKWCBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:01:45 -0500
Received: from ozlabs.org ([203.10.76.45]:47283 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbZKWCBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:01:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] vhost: Fix warnings and bad type handling
Date: Mon, 23 Nov 2009 12:31:44 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Alan Cox <alan@linux.intel.com>, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091117154213.3683.94554.stgit@localhost.localdomain> <20091122102801.GA13644@redhat.com>
In-Reply-To: <20091122102801.GA13644@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911231231.45095.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 08:58:01 pm Michael S. Tsirkin wrote:
> 
> From: Alan Cox <alan@linux.intel.com>
> Subject: [PATCH] vhost: fix warnings on 32 bit systems
> 
> Fix compiler warning about discarding top 32 bit
> of data on 32 bit systems, and document that
> dicarded bits must be 0.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> So I think the below slightly tweaked version of
> Alan's patch is a bit better. OK?

Thanks, applied.

Rusty.
