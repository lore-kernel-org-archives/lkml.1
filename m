Return-Path: <linux-kernel-owner+w=401wt.eu-S1761900AbZEHPXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900AbZEHPXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760497AbZEHPXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:23:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:38012 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858AbZEHPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:23:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pOx6GwnbQgiLpnysgaVqaNkmQ5nXopwVcmT/+qVkHneQQ3aFDH8MZ6EppcnqtbCYMl
         dO8geoXt8cjQt5WVowXkXpf8tiAKOa6gIkmxdyEOcQ1cRcZ3QK43YfBJW9K1TZ6b/9jN
         YhY6pki5ouMQiLxHhJp6tNU5L8aOl1yOagZ8g=
Date: Fri, 8 May 2009 19:23:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       cl@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rientjes@google.com
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
Message-ID: <20090508152314.GK6132@lenovo>
References: <1241795429.28600.61.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241795429.28600.61.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Fri, May 08, 2009 at 06:10:29PM +0300]
| From: Pekka Enberg <penberg@cs.helsinki.fi>
| 
| This patch converts SLUB early-boot code to use GFP_PANIC instead of explicit
| BUG_ON() calls.
| 
| Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
| ---
|  mm/slub.c |    8 +++-----
|  1 files changed, 3 insertions(+), 5 deletions(-)
|

If the idea will be accepted -- I add 3 callsites on x86
area too :)

	-- Cyrill
