Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbXFBHAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbXFBHAn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXFBHAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:00:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:59830 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbXFBHAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=O1sqqNjNENQ4kiWV/+diWA6pFQmIT1xekgy0PdOLYl06D1B8Dx0y9/JGaTg8WNzFxjMmEoxKBQtW3VrEdxzRESi3PQ7FMfl2Dzk/AyHNvufdKF3of0Hb8DApcAmCr8/HLrWdbQ66d5VzCqCXR9oxp36+5Uh82OklTN1e1I4asmU=
Date: Sat, 2 Jun 2007 10:59:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Eric Sandeen <sandeen@sandeen.net>,
       Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070602065923.GB8387@cvg>
References: <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <20070601211036.GA23975@duck.suse.cz> <46609FBD.5040407@sandeen.net> <20070601154834.53558d1b.akpm@linux-foundation.org> <4660FD7F.4090302@sandeen.net> <20070601224339.c803e04e.akpm@linux-foundation.org> <20070602063403.GA8387@cvg> <20070601235422.fdc1f750.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601235422.fdc1f750.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Fri, Jun 01, 2007 at 11:54:22PM -0700]
| On Sat, 2 Jun 2007 10:34:03 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > | That patch is DOA, methinks.
| > | 
| > 
| > Andrew, what does it mean - "DOA"? Dead on arrival?
| 
| yes - I dropped it.
| 

But that could lead to rejection of my code-style-conversion patch...
Should I remake them?

Actually Jan was right, the current state of UDF (without his patches)
could lead to lost blocks and his patch must be just fixed I think.

		Cyrill

