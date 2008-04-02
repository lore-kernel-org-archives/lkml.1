Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYDBHrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYDBHrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYDBHro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:47:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56694 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685AbYDBHrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:47:43 -0400
Message-ID: <47F33A1D.3050301@sgi.com>
Date: Wed, 02 Apr 2008 00:47:41 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpuset_scnprintf function
References: <20080401225422.064890000@polaris-admin.engr.sgi.com> <20080402012006.1722c2bd.pj@sgi.com>
In-Reply-To: <20080402012006.1722c2bd.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> However doing this is worse in my view than simply breaking the format
> outright, unilaterally and irrevocably.  If you just flat out stick a
> fork in an API and break it hard on some release, then at least user
> space knows that it must adapt or die at that version.  If you hand
> user space the means to break that API, then any properly and
> defensively written user code has to be prepared to deal with both API
> flavors, and the majority of user space code is broken half the time,
> when run on a system with the API variant it wasn't expecting.  More
> over, you end up with apps having "toilet seat wars" with each other:
> you left it up and it should be down; no you left it down and it should
> be up.  Not a pretty sight.
> 
> Perhaps I totally misunderstand this patchset ?
> 

Hi,

I wanted to not break current apps unmercifully, but perhaps I should
default it to the "non-compatible" mode (and adjust the schedstat version
to indicate this)?  [It's the only output that I found that seemed to care.]

And if users have apps that they can't convert, they can revert to the
"old" (compatible) method of outputs.  I know if I'm a user and I'm really
interested in understanding the outputs when there's hundreds and hundreds
of cpus, then the more compact format is much more useful.

I can't believe there hasn't been many changes in all of these outputs.
Like what happened before Hyperthreading, or 3rd level caches, or ?
Even the new Intel announcements for Nehalem may introduce more changes
in what's important in the output information.  Plus I was under the
impression that one of the basic tenets of Linux was that API's can and
will change?

Thanks,
Mike
