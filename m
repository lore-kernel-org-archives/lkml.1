Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZKWIym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZKWIym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZKWIyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:54:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZKWIyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:54:40 -0500
Subject: Re: [PATCH 0/1] Defer skb allocation for both mergeable buffers
 and big packets in virtio_net
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Shirley Ma <mashirle@us.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       Avi Kivity <avi@redhat.com>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <200911231123.18898.rusty@rustcorp.com.au>
References: <1258697359.7416.14.camel@localhost.localdomain>
	 <200911231123.18898.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 08:51:50 +0000
Message-Id: <1258966310.14708.11.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 11:23 +1030, Rusty Russell wrote:
> I'd like to drop big packet support from our driver, but I don't know
> how many kvm hosts will not offer mergable rx bufs yet.  Anthony?

Mergeable rx bufs were first added in kvm-80 and qemu-0.10.0

So e.g., it's in Fedora since Fedora 11 and RHEL since 5.4

Cheers,
Mark.

