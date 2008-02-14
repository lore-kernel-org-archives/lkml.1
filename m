Return-Path: <linux-kernel-owner+w=401wt.eu-S1764179AbYBNK0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764179AbYBNK0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYBNKZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:25:50 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:43885 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYBNKZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:25:49 -0500
Date: Thu, 14 Feb 2008 11:22:44 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: mikael.starvik@axis.com, dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: Re: cris/arch-v10/lib/memset.c compile error
Message-ID: <20080214102244.GZ11007@axis.com>
References: <20080213185703.GC14269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213185703.GC14269@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 08:57:03PM +0200, Adrian Bunk wrote:
> Trying to compile a cris defconfig with an svn gcc (that will become
> gcc 4.3) fails with the following error:

Ah, yes. Cast doesn't return an lvalue. I've also seen this (as a
warning) when running with sparse with the 3.2.1 gcc.

I'll do something about that and get back to you with a patch.

>   CC      arch/cris/arch-v10/lib/memset.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c: In function 'memset':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/memset.c:164: error: lvalue required as increment operand
> [snip]

Thanks for the heads up.

> cu
> Adrian

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
