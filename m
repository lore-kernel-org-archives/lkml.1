Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbXHBWvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbXHBWvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbXHBWvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:51:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbXHBWvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:51:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [RFC, PATCH] handle the multi-threaded init's exit() properly
In-Reply-To: Oleg Nesterov's message of  Friday, 3 August 2007 01:20:09 +0400 <20070802212009.GA516@tv-sign.ru>
X-Shopping-List: (1) Sunburnt robber winters
   (2) Astronautical pincushion salmon
   (3) Courageous relaxers
   (4) Recreational transient suction
   (5) Reminiscent hand pancakes
Message-Id: <20070802225127.3EC214D04B5@magilla.localdomain>
Date: Thu,  2 Aug 2007 15:51:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This looks fine to me, though I don't know anything about the nsproxy bit.
Now that choose_new_parent is one trivial line, you might go on to get rid
of it and roll its one line into reparent_thread.


Thanks,
Roland
