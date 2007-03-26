Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXCZT0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXCZT0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbXCZT0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:26:25 -0400
Received: from alnrmhc14.comcast.net ([204.127.225.94]:48342 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXCZT0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:26:24 -0400
Date: Mon, 26 Mar 2007 11:46:56 -0700
From: Christopher Li <sparse@chrisli.org>
To: Russ Cox <rsc@swtch.com>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH] Add const to pointer qualifiers for __chk_user_ptr and __chk_io_ptr.
Message-ID: <20070326184656.GB24841@chrisli.org>
References: <ee9e417a0703260823k55c6de8ay715be1db11692355@mail.gmail.com> <20070326180155.GA24764@chrisli.org> <ee9e417a0703261159g6aeed343t58a98c5f45141c53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee9e417a0703261159g6aeed343t58a98c5f45141c53@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 02:59:39PM -0400, Russ Cox wrote:
> No, you have it backward.
> It is valid to pass void* to a const void* function.
> It is *not* valid to pass const void* to a void* function.
> 
> Right now __chk_user_ptr is a void* function, meaning
> that all the places where it gets passed a const void*
> are technically illegal -- gcc would warn about these, and
> it is a (separate, as you observed) bug that sparse does not.
> 
> The patch changes __chk_user_ptr to be a const void*
> function, meaning that it will be legal to pass either void*
> or const void* to it.  This is the correct semantics.

Hah, I see. Thanks for the explain.

Ack.

Chris
