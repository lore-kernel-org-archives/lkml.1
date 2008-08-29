Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYH2L4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYH2L4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYH2L4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:56:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:32985 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbYH2L4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:56:38 -0400
Message-ID: <48B7E388.3000403@kernel.org>
Date: Fri, 29 Aug 2008 13:54:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Roger Willcocks <roger@filmlight.ltd.uk>
CC: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org>	<1219945263-21074-6-git-send-email-tj@kernel.org>	<20080828175116.GB18461@kroah.com>	<48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org>	<E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>	<48B6EBBD.6050406@kernel.org>	<E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>	<48B6EF98.4070008@kernel.org>	<E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>	<48B6FFB6.7000104@kernel.org>	<E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu> <48B75C94.7030604@kernel.org> <48B7DDF7.7060107@filmlight.ltd.uk>
In-Reply-To: <48B7DDF7.7060107@filmlight.ltd.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 11:56:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Willcocks wrote:
> One thing to bear in mind is the possibility of 32-bit client programs
> running on a 64-bit platform, so your user-space driver will need be be
> aware of the flavour of the client, and parse the ioctl arguments (and
> in particular, pointers) appropriately.
> 
> That's true of a kernel implementation too, of course.

Yeap, for 32bit client on 64bit machine, FUSE_IOCTL_COMPAT will be set.
 For OSS emulation, it doesn't make any difference tho.  It's the same
for both word sizes.

Thanks.

-- 
tejun
