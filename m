Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYC1UUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYC1UUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYC1UTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:19:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2058 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753641AbYC1UTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:19:51 -0400
Date: Fri, 28 Mar 2008 21:19:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/7] omfs: define filesystem structures
Message-ID: <20080328201940.GA3974@ucw.cz>
References: <1206578760-9050-1-git-send-email-me@bobcopeland.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206578760-9050-1-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-26 20:45:54, Bob Copeland wrote:
> OMFS is a proprietary filesystem created for the ReplayTV and
> also used by the Rio Karma.  It uses hash tables with unordered,
> unbounded lists in each bucket for directories, extents for

Why did they create such beast?

> +struct omfs_header {
> +	__be64 h_self;
> +	__be32 h_body_size;
> +	__be16 h_crc;
> +	char h_fill1[2];
> +	u8 h_version;
> +	char h_type;
> +	u8 h_magic;
> +	u8 h_check_xor;
> +	__be32 h_fill2;
> +};

attribute packed or something? Some strange machine (alpha?) may
decide to align u8s at 32bit boundaries...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
