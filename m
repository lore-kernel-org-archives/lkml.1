Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZLOAta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZLOAta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZLOAta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:49:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57667 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZLOAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:49:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <1260810481.6666.13.camel@dhcp-100-19-198.bos.redhat.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <1260810481.6666.13.camel@dhcp-100-19-198.bos.redhat.com>
Message-Id: <20091215094815.CDBB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 09:49:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2009-12-11 at 16:46 -0500, Rik van Riel wrote:
> 
> Rik, the latest patch appears to have a problem although I dont know
> what the problem is yet.  When the system ran out of memory we see
> thousands of runnable processes and 100% system time:
> 
> 
>  9420  2  29824  79856  62676  19564    0    0     0     0 8054  379  0 
> 100  0  0  0
> 9420  2  29824  79368  62292  19564    0    0     0     0 8691  413  0 
> 100  0  0  0
> 9421  1  29824  79780  61780  19820    0    0     0     0 8928  408  0 
> 100  0  0  0
> 
> The system would not respond so I dont know whats going on yet.  I'll
> add debug code to figure out why its in that state as soon as I get
> access to the hardware.
> 
> Larry

There are 9421 running processces. it mean concurrent task limitation
don't works well. hmm?



