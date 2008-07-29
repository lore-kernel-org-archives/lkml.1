Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYG2CAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYG2CAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYG2CAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:00:25 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:52606 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYG2CAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:00:24 -0400
X-Greylist: delayed 1990 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 22:00:23 EDT
Date: Mon, 28 Jul 2008 21:27:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] omfs: sparse annotations
Message-ID: <20080729012706.GA1775@hash.localnet>
References: <1217291327.23389.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217291327.23389.1.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 05:28:46PM -0700, Harvey Harrison wrote:
> Missing cpu_to_be64 on some constant assignments.
>
> -	oi->i_sibling = ~0ULL;
> +	oi->i_sibling = ~cpu_to_be64(0ULL);

Thanks, I saw these sparse warnings before but wasn't sure how to fix
them.  

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

