Return-Path: <linux-kernel-owner+w=401wt.eu-S934010AbYAaQvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010AbYAaQvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765631AbYAaQvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:51:19 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59007 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765121AbYAaQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:51:18 -0500
Date: Thu, 31 Jan 2008 11:51:17 -0500
To: Lars Noschinski <lklml@ml.noschinski.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How does ext2 implement sparse files?
Message-ID: <20080131165117.GC26259@csclub.uwaterloo.ca>
References: <20080131152823.GA29422@lars.home.noschinski.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131152823.GA29422@lars.home.noschinski.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 04:28:23PM +0100, Lars Noschinski wrote:
> For an university project, we had to write a toy filesystem (ext2-like),
> for which I would like to implement sparse file support. For this, I
> digged through the ext2 source code; but I could not find the point,
> where ext2 detects holes.
> 
> As far as I can see from fs/buffer.c, an hole is a buffer_head which is
> not mapped, but uptodate. But I cannot find a relevant source line,
> where ext2 makes usage of this information.
> 
> Any hints would be greatly appreciated,

While I don't actually know, I always thought it was up to the
application to create files with holes by seeking over the holes before
writing data.  That seems like the simplest way to me.

--
Len Sorensen
