Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYFPNbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYFPNbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYFPNb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:31:29 -0400
Received: from [194.117.236.238] ([194.117.236.238]:39788 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYFPNb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:31:29 -0400
Date: Mon, 16 Jun 2008 16:30:46 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 3/3] relay: Add buffer-only channels; useful for early
 logging.
Message-ID: <20080616163046.6f93ec04@linux360.ro>
In-Reply-To: <20080616123535.GD18561@Krystal>
References: <20080613041013.274ccb28@linux360.ro>
	<20080616123535.GD18561@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 08:35:35 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
 
> I think it would be good to add a patch to this patch series which
> allows to allocate such early boot buffers either statically in a
> kernel menuconfig option or in a kernel command line argument, so we
> do not depend on vmap. That would make it usable "very early".
> 
> Mathieu

This can be done, but it would require rewriting much of what relay
uses to allocate structures and buffers. I've decided with my mentor,
Pekka Enberg, that kmemtrace doesn't need this so much, so this is on
my low priority list. I agree it would be nice, but it probably won't
happen until kmemtrace is done.

The bright side is most of this patch will still be valid if we choose
to implement static buffers. So this _is_ a step in that direction.


	Eduard
