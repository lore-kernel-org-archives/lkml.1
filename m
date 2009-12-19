Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZLSSjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZLSSjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 13:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZLSSjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 13:39:47 -0500
Received: from ns1.coraid.com ([12.51.113.4]:57768 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbZLSSjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 13:39:46 -0500
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Dec 2009 13:39:46 EST
Date: Sat, 19 Dec 2009 13:22:54 -0500
From: Ed Cashin <ecashin@coraid.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/7] drivers/block/aoe: Use kzalloc for allocating only one thing
Message-ID: <20091219182254.GB2266@Ed-Cashins-MacBook-Pro.local>
References: <Pine.LNX.4.64.0912190815550.30546@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912190815550.30546@ask.diku.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 08:16:13AM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use kzalloc rather than kcalloc(1,...)

I suppose so.  The calloc function has always been silly, but
everybody knows that, so I don't really think this patch helps
anything.  I guess somebody disagrees with me.
