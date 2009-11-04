Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbZKDHR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbZKDHR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZKDHR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:17:58 -0500
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:35056
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbZKDHR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:17:58 -0500
Date: Wed, 4 Nov 2009 08:17:50 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091104071750.GA19287@gibson.comsick.at>
References: <20091102122010.GA5552@gibson.comsick.at>
 <200911040114.08879.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911040114.08879.elendil@planet.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04 Nov 09 01:14, Frans Pop wrote:
> Thanks Michael. That means we now have two cases where reverting the 
> congestion_wait() changes from .31-rc3 (8aa7e847d8 + 373c0a7ed3) makes a 
> clear and significant difference.
> 
> I wonder if more effort could/should be made on this aspect.

Good morning Frans,

As a cross check I reverted the revert here and tried to reproduce the
problem again. It is a lot harder to trigger for me now (I was not able
to reproduce it yet). I did update my local git tree though, can you
reproduce this problem on your side with current git?

Kind regards,
Michael
