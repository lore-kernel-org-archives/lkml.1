Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbYA2GU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbYA2GU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYA2GUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:20:22 -0500
Received: from ozlabs.org ([203.10.76.45]:33992 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYA2GUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:20:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] Module: check to see if we have a built in module with the same name
Date: Tue, 29 Jan 2008 17:20:19 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-3-git-send-email-gregkh@suse.de>
In-Reply-To: <1201477122-4541-3-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291720.19781.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 10:38:40 Greg Kroah-Hartman wrote:
> When trying to load a module with the same name as a built-in one, a
> scary kobject backtrace comes up.  Prevent that from checking for this
> condition and warning the user as to what exactly is going on.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  kernel/module.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

Oh, I pushed this as part of my module updates.

Unfortunately Andrew still doesn't seem to have picked up my patch queue, and 
keeps grabbing random (sometimes outdated) patches which are also in my 
tree :(

Cheers,
Rusty.
