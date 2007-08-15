Return-Path: <linux-kernel-owner+w=401wt.eu-S936035AbXHOWYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936035AbXHOWYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbXHOWX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:23:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33895 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbXHOWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:23:58 -0400
Date: Thu, 16 Aug 2007 00:23:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Eliminate result signage problem in asm-x86_64/bitops.h
Message-ID: <20070815222355.GA5069@one.firstfloor.org>
References: <20070815204939.3518.63203.stgit@monet.1015granger.net> <20070815210247.3518.89243.stgit@monet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815210247.3518.89243.stgit@monet.1015granger.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 05:02:47PM -0400, Chuck Lever wrote:
> The return type of __scanbit() doesn't match the return type of
> find_{first,next}_bit().  Thus when you construct something like
> this:
> 
>    boolean ? __scanbit() : find_first_bit()

Why would you want to write this?  What is boolean?
Do they have different arguments?

It's on my todo list for some time to special case
f_f_b() and friends for smaller arguments. Would
that eliminate this construct?

-Andi
