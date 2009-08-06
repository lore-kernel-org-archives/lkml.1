Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZHFLqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZHFLqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZHFLqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:46:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbZHFLqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:46:01 -0400
Date: Thu, 6 Aug 2009 12:45:50 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Mark McLoughlin <markmc@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] block: silently error unsupported empty
	barriers too
Message-ID: <20090806114550.GL29899@agk-dp.fab.redhat.com>
Mail-Followup-To: Mark McLoughlin <markmc@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <1249557257.3721.55.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249557257.3721.55.camel@blaa>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 12:14:17PM +0100, Mark McLoughlin wrote:
> We should error all barriers, even empty barriers, on devices like
> virtio_blk which don't support them.
 
Have you considered whether or not virtio_blk actually needs to
support empty barriers?

Alasdair

