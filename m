Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212Ab0AMRce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab0AMRce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115Ab0AMRcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:32:33 -0500
Received: from sous-sol.org ([216.99.217.87]:39396 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756091Ab0AMRcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:32:32 -0500
Date: Wed, 13 Jan 2010 09:31:52 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Message-ID: <20100113173152.GA2666@sequoia.sous-sol.org>
References: <20100113093119.GT7549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113093119.GT7549@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gleb Natapov (gleb@redhat.com) wrote:
> If application does mlockall(MCL_FUTURE) it is no longer possible to mmap
> file bigger than main memory or allocate big area of anonymous memory
> in a thread safe manner. Sometimes it is desirable to lock everything
> related to program execution into memory, but still be able to mmap
> big file or allocate huge amount of memory and allow OS to swap them on
> demand. MAP_UNLOCKED allows to do that.
>  
> Signed-off-by: Gleb Natapov <gleb@redhat.com>

Looks good to me.

Acked-by: Chris Wright <chrisw@sous-sol.org>

thanks,
-chris
