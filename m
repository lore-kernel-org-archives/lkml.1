Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXKNMkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXKNMkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbXKNMkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:40:36 -0500
Received: from brick.kernel.dk ([87.55.233.238]:11271 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbXKNMkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:40:35 -0500
Date: Wed, 14 Nov 2007 13:39:31 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Attempt to get eject failures back to ioctl(CDROMEJECT)
Message-ID: <20071114123931.GF5064@kernel.dk>
References: <200711141739.46960.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711141739.46960.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14 2007, Rusty Russell wrote:
> Hi Jens,
> 
>     As you asked for some time ago.  Of course, it turns out that the eject
> command ignores the error anyway, but it's nice that it now errors.
> 
>     Not entirely comfortable with this patch: there's a req->errors but
> that seems to have some existing semantics I'm not sure of, so I simply
> added a new way of flagging an error.

It is a bit of a hack, but it's not really your fault. ->errors is
somewhat messy and has different meaning depending on the request type.
I'll add your patch and then do a sanitize on top of it, so that we can
switch things over to a unified ->errno instead.

-- 
Jens Axboe

