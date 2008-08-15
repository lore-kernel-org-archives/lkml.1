Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYHOLft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYHOLft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYHOLfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:35:39 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:2955 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYHOLfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:35:38 -0400
Date: Fri, 15 Aug 2008 07:35:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       snakebyte@gmx.de
Subject: Re: [PATCH 1/2] omfs: fix potential oops when directory size is corrupted
Message-ID: <20080815113551.GA32649@hash.localnet>
References: <1218770022-31956-1-git-send-email-me@bobcopeland.com> <20080815001956.6b16f383.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815001956.6b16f383.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 12:19:56AM -0700, Andrew Morton wrote:
> We don't need to use i_size_write() on this code path, but we do in other
> places.  There's also i_size_read().  I wonder if omfs gets it right
> everywhere..

Good point, probably not.  I'll audit for this...

-- 
Bob Copeland %% www.bobcopeland.com

