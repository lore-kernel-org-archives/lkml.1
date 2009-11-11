Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbZKKXZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbZKKXZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbZKKXZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:25:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759609AbZKKXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:25:00 -0500
Date: Wed, 11 Nov 2009 15:24:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zlib: Optimize inffast even more
Message-Id: <20091111152445.7d2f8643.akpm@linux-foundation.org>
In-Reply-To: <1257762136-17593-1-git-send-email-Joakim.Tjernlund@transmode.se>
References: <1257762136-17593-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009 11:22:16 +0100
Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:

> This improves zlib: Optimize inffast when copying direct from output
> and gives another 3-4% improvement for my MPC8321 target.
> Does not need CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,
> uses get_unaligned() but only in one place.
> The copy loop just above this one can also use this
> optimization, but I havn't done so as I have not tested if it
> is a win there too.
> 
> Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> ---
> 
>  Someone with a little endian target should test too.

eh?  That requires a PC.  Can't you test it??
