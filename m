Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYBRIjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYBRIjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYBRIjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:39:33 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:51704 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbYBRIjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:39:32 -0500
Date: Mon, 18 Feb 2008 09:39:12 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: mikael.starvik@axis.com, dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: Re: cris/arch-v10/lib/string.c compile error
Message-ID: <20080218083912.GK11007@axis.com>
References: <20080216095739.GE9962@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216095739.GE9962@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 11:57:39AM +0200, Adrian Bunk wrote:
> Next file, same problem:
> <--  snip  -->
> 
> ...
>   CC      arch/cris/arch-v10/lib/string.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:138: error: lvalue required as increment operand
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:138: error: lvalue required as increment operand
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/cris/arch-v10/lib/string.c:139: error: lvalue required as increment operand
> ...
> 
> <--  snip  -->
> 
> And looking at Jan Dittmer's page [1] that problem is not limited to the 
> SVN head gcc I'm using since he's running into the same error with
> gcc 4.0.4.
> 
> Can you try compiling a cris kernel with a gcc 4 based toolchain?

Yes, I'll set that up and squash the compile errors in one go.

Thanks again for the heads up.

> cu
> Adrian
> 
> [1] http://l4x.org/k/?d=38964

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
