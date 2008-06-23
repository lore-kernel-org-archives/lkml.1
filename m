Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYFWCo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYFWCo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYFWCor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:44:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:46903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYFWCoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:44:46 -0400
Date: Mon, 23 Jun 2008 04:44:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] get_user_pages: minor code tweaks
Message-ID: <20080623024445.GD29413@wotan.suse.de>
References: <20080621134125.GA10854@tv-sign.ru> <20080621140741.GA13422@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621140741.GA13422@tv-sign.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 06:07:41PM +0400, Oleg Nesterov wrote:
> On 06/21, Oleg Nesterov wrote:
> >
> > No functional changes.
> 
> Heh.
> 
> > 2. Move "foll_flags |= FOLL_WRITE;" from the inner loop up.
> 
> Please ignore this patch, it is wrong. FOLL_WRITE can be cleared after
> handle_mm_fault().

Patch 1/2 is good, though. Please get it upstream.
