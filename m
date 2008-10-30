Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYJ3Lyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYJ3Lyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYJ3Lyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:54:39 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:34202 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYJ3Lyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:54:38 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 07:54:38 EDT
Date: Thu, 30 Oct 2008 12:47:08 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] Really remove unwinder
Message-ID: <20081030114708.GC12152@boogie.lpds.sztaki.hu>
References: <20081030112023.GA27476@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030112023.GA27476@x200.localdomain>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 30, 2008 at 02:20:23PM +0300, Alexey Dobriyan wrote:

> -static inline void unwind_init(void) {}

[...]

> -	/*
> -	 * Need to run as early as possible, to initialize the
> -	 * lockdep hash:
> -	 */
> -	unwind_init();
>  	lockdep_init();
>  	debug_objects_early_init();

IMHO the comment does not refer to unwind_init() so it should not be
removed...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
