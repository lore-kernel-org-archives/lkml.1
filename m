Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbZC0Jft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbZC0Jft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbZC0Jej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:34:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49433 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074AbZC0Jei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:34:38 -0400
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: DRM lock ordering fix series
From: Andi Kleen <andi@firstfloor.org>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
Date: Fri, 27 Mar 2009 10:34:30 +0100
In-Reply-To: <1238017510-26784-1-git-send-email-eric@anholt.net> (Eric Anholt's message of "Wed, 25 Mar 2009 14:45:04 -0700")
Message-ID: <87ocvnmhqx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Anholt <eric@anholt.net> writes:

> Here's hopefully the final attempt at the lock ordering fix for GEM.  The
> problem was introduced in .29 with the GTT mapping support.  We hashed out
> a few potential fixes on the mailing list and at OSTS.  Peter's plan was
> to use get_user_pages, but it has significant CPU overhead (10% cost to text
> rendering, though part of that is due to some dumb userland code.  But it's
> dumb userland code we're all running).


You are aware that there is a fast path now (get_user_pages_fast) which
is significantly faster? (but has some limitations)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
