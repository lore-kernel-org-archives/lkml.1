Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYE2HVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYE2HVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYE2HU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:20:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbYE2HU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:20:57 -0400
Date: Thu, 29 May 2008 00:20:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block: make blktrace use per-cpu buffers for message notes
Message-Id: <20080529002016.df6cd8c8.akpm@linux-foundation.org>
In-Reply-To: <20080529070915.GK25504@kernel.dk>
References: <200805281559.m4SFx7b9022392@hera.kernel.org>
	<20080528231351.a35001bc.akpm@linux-foundation.org>
	<20080529062214.GG25504@kernel.dk>
	<20080528233801.e9e55eeb.akpm@linux-foundation.org>
	<20080529064520.GJ25504@kernel.dk>
	<20080529070915.GK25504@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 09:09:15 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> So I dug back into the old archives, and the patch was actually done
> by me back in feb 2006. Not sure I particularly like it or if it
> even works in this forward ported version, but it should get the
> point across. blktrace is the sole user of relay_reserve(), so I
> think it would be OK to change the interface.
> 
> This is clearly NOT 2.6.26 material though, but it's food for
> thought (I hope).

hm, it's not pretty, is it.  I think I prefer the existing code unless
there are other users of this.
