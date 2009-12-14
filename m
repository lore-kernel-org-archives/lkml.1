Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbZLNXW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbZLNXW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZLNXW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:22:27 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46767 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZLNXW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:22:26 -0500
Subject: Re: [PATCH v2 1/4] Defer skb allocation -- add destroy buffers
 function for virtio
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <20091214202253.GG6150@redhat.com>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <200911231123.18898.rusty@rustcorp.com.au>
	 <20091208122134.GA17286@redhat.com>
	 <1260534506.30371.6.camel@localhost.localdomain>
	 <1260534805.30371.10.camel@localhost.localdomain>
	 <20091213102632.GB6789@redhat.com>
	 <1260821285.8716.7.camel@localhost.localdomain>
	 <20091214202253.GG6150@redhat.com>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 15:22:22 -0800
Message-Id: <1260832942.4387.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

On Mon, 2009-12-14 at 22:22 +0200, Michael S. Tsirkin wrote:
> I dont insist, but my idea was
> 
> for (;;) {
>         b = vq->destroy(vq);
>         if (!b)
>                 break;
>         --vi->num;
>         put_page(b);
> }
> 
> so we do not have to lose track of the counter.

That's not a bad idea, but to do this, then this fuction will be
specific for virtio_net device (vi is virtnet_info) only in a generic
virtqueue API.

Thanks
Shirley

