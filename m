Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYDFLxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYDFLxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 07:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbYDFLxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 07:53:16 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:48307 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYDFLxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 07:53:15 -0400
Message-ID: <47F8B98A.1020704@panasas.com>
Date: Sun, 06 Apr 2008 14:52:42 +0300
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Engelhardt <jengelh@computergmbh.de>, apw@shadowen.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080405221822.376f0018.akpm@linux-foundation.org>
In-Reply-To: <20080405221822.376f0018.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 06, 2008, 8:18 +0300, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 6 Apr 2008 06:54:54 +0200 (CEST) Jan Engelhardt <jengelh@computergmbh.de> wrote:
> 
>>      We all had the arguments about 80 columns, so here goes a relax.
>>      Checking for 95 (or perhaps something better?), but of course we
>>      print "80" in the output, because if you happened to get to 95, it's
>>      "really time" to break it.
> 
> This will reduce the usefulness of checkpatch for those developers who
> choose to observe an 80-column limit.
> 
>>      This also relaxes the tab doctrine, because spaces DO make sense --
>>      especially when you view the code with a tab setting of not-8.
> 
> Non-tab-using code inevitably ends up having a mix of tabs and non-tabs
> and looks a mess if tabstops are set to anything other than eight.

I humbly disagree.  If you use tabs for (logical) indentation and then trailing
spaces for (graphical) alignment, not just a random mix of tabs and spaces the
code looks fine with 8-character wide tabs or any other setup.  Only when you
use tabs for graphical alignment, below fixed-width characters on the line above
you marry yourself with a specific tab expansion width.

Benny

> 
> God I wish I had not been cc'ed on this.

The idea is *not* to open the flood gates, just to allow for a bit more
flexibility to accommodate for a more robust indentation style.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

