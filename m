Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZHRWov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZHRWov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZHRWou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:44:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:1577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZHRWou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:44:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,404,1246863600"; 
   d="scan'208";a="542625986"
Date: Tue, 18 Aug 2009 15:44:42 -0700
From: mgross <mgross@linux.intel.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH, RESEND 0/2] pm_qos: remove BKL and de-race
Message-ID: <20090818224442.GA16014@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20090813140554.014ce1e0@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813140554.014ce1e0@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 02:05:54PM -0600, Jonathan Corbet wrote:

Sorry for the late reply.  I'll look over the patches shortly.

--mgross

> Here's a repost of my two-patch set getting rid of the BKL and some
> racy code in pm_qos_params.c.  There's been no changes since the last
> time around other than the addition of a couple of tags.  Patches
> follow, or they can be pulled from:
> 
> 	git://git.lwn.net/linux-2.6.git bkl-removal
> 
> Ingo, you didn't say whether these could find a home in your
> violent-death-to-the-bkl tree until the merge window opens.  So they're
> still looking for a place to rest; I guess I could ask Stephen to take
> the bkl-removal tree back into linux-next, but that seems like
> overkill.
> 
> Thanks,
> 
> jon
