Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYAZOaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYAZOaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 09:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYAZOaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 09:30:11 -0500
Received: from main.gmane.org ([80.91.229.2]:58298 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbYAZOaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 09:30:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Date: Sat, 26 Jan 2008 14:27:04 +0000 (UTC)
Message-ID: <loom.20080126T142451-347@post.gmane.org>
References: <1200949086.6648.19.camel@Anastacia> <200801221625.58615.nickpiggin@yahoo.com.au> <1201354155.6853.4.camel@Anastacia> <200801270046.26648.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 82.229.208.82 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20070914 Firefox/2.0.0.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin <at> yahoo.com.au> writes: 
> On Sunday 27 January 2008 00:29, Frederik Himpe wrote:
> > I just succeeded to reproduce the problem with this patch. Does this
> > smell like an XFS problem?

I got the same issue using ext3

> Possible. Though I think it is more likely to be a bug in the
> new deadlock avoidance code in the generic buffered write path.
> Dang... I wonder why this hasn't come up earlier. It looks like
> pan's use of writev might be tickling it.
> 
> How quickly can you reproduce this?

When I was using pan daily one month ago, I got it twice over a week

> Can you use strace to see what the hanging syscall looks like?

I tried last week during 5 hours without luck, I can try again

