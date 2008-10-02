Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbYJCBbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbYJCBbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 21:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYJCBbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 21:31:10 -0400
Received: from ozlabs.org ([203.10.76.45]:60456 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYJCBbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 21:31:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 1/5] virtio_blk: change to use __blk_end_request()
Date: Thu, 2 Oct 2008 14:52:46 +1000
User-Agent: KMail/1.9.9
Cc: jens.axboe@oracle.com, oakad@yahoo.com, adrian@mcmen.demon.co.uk,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       j-nomura@ce.jp.nec.com
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com> <20081001.101120.41628825.k-ueda@ct.jp.nec.com>
In-Reply-To: <20081001.101120.41628825.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021452.47136.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2008 00:11:20 Kiyoshi Ueda wrote:
> This patch converts virtio_blk to use __blk_end_request() directly
> so that end_{queued|dequeued}_request() can be removed.
> Related 'uptodate' argument is converted to 'error'.

Hi Kiyoshi,

   Nice and clear; now matches common kernel style.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
