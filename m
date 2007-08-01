Return-Path: <linux-kernel-owner+w=401wt.eu-S1762543AbXHARab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762543AbXHARab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbXHARaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:30:24 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:35941 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756548AbXHARaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:30:24 -0400
Subject: Re: [PATCH] FRV: Make BSG declarations dependent on CONFIG_BLOCK
From: James Bottomley <James.Bottomley@SteelEye.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <28317.1185979496@redhat.com>
References: <1185976630.3468.73.camel@localhost.localdomain>
	 <20070801091353.10608.32356.stgit@warthog.cambridge.redhat.com>
	 <28317.1185979496@redhat.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 12:30:21 -0500
Message-Id: <1185989421.3468.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 15:44 +0100, David Howells wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > Are you sure you're testing with git head?  CONFIG_BLK_DEV_BSG cannot be
> > set unless CONFIG_BLOCK is (which was a bug in previous releases now
> > fixed in git head ... unless the fix has gone wrong?).
> 
> Neither CONFIG_BLK_DEV_BSG nor CONFIG_BLOCK are set.  The problem is that the
> stub BSG functions refer to undefined structures when CONFIG_BLOCK=n.

Hmm, then isn't the fix to add a struct request_queue; and other
definitions above the stub functions?

What is the file that's causing this actual problem ... as in what still
needs to pull in the block headers if CONFIG_BLOCK=n (or more properly,
could it also need to use the bsg stub functions?)

James


