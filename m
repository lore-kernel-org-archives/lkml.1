Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844Ab0ANGuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0ANGuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 01:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559Ab0ANGuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 01:50:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab0ANGuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 01:50:16 -0500
Date: Thu, 14 Jan 2010 08:50:08 +0200
From: Gleb Natapov <gleb@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Message-ID: <20100114065008.GC18808@redhat.com>
References: <20100113093119.GT7549@redhat.com>
 <20100114092845.D719.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114092845.D719.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 09:31:03AM +0900, KOSAKI Motohiro wrote:
> > If application does mlockall(MCL_FUTURE) it is no longer possible to mmap
> > file bigger than main memory or allocate big area of anonymous memory
> > in a thread safe manner. Sometimes it is desirable to lock everything
> > related to program execution into memory, but still be able to mmap
> > big file or allocate huge amount of memory and allow OS to swap them on
> > demand. MAP_UNLOCKED allows to do that.
> >  
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > ---
> > 
> > I get reports that people find this useful, so resending.
> 
> This description is still wrong. It doesn't describe why this patch is useful.
> 
I think the text above describes the feature it adds and its use
case quite well. Can you elaborate what is missing in your opinion,
or suggest alternative text please?

--
			Gleb.
