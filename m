Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZFHNpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZFHNpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZFHNpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:45:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41010 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbZFHNpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:45:32 -0400
Message-ID: <4A2D15DD.1030005@redhat.com>
Date: Mon, 08 Jun 2009 09:45:01 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] Add a gfp-translate script to help understand page	allocation
 failure reports
References: <20090608132950.GB15070@csn.ul.ie>
In-Reply-To: <20090608132950.GB15070@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

>   mel@machina:~/linux-2.6 $ scripts/gfp-translate 0x4020
>   Source: /home/mel/linux-2.6
>   Parsing: 0x4020
>   #define __GFP_HIGH	(0x20)	/* Should access emergency pools? */
>   #define __GFP_COMP	(0x4000) /* Add compound page metadata */
> 
> The script is not a work of art but it has come in handy for me a few times
> so I thought I would share.

Sweet.  This is just what I've been waiting for!

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
