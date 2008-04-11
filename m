Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYDKA0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYDKA0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 20:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYDKA0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 20:26:33 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41629 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYDKA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 20:26:32 -0400
Date: Thu, 10 Apr 2008 20:26:30 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: guilt@josefsipek.net
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Guilt: Autotagging - aye or nay?
Message-ID: <20080411002630.GD3838@josefsipek.net>
References: <20080411000143.GC3838@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411000143.GC3838@josefsipek.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all!

I was trying to figure out what the default for Guilt's autotagging feature
should be.  Currently, the default is for it to be on, unless it's
overridden by an already existing config setting.

For those who may not be familiar with autotagging, here's an excerpt from
the guilt(7) man page:

	Autotagging is a feature that automatically creates unannotated tags
	for top, bottom, and base of the stack.

	On every push or pop operation (refresh is a pop followed by a
	push), Guilt updates the stack top (${branch}_top), stack bottom
	(${branch}_bottom), and stack base (${branch}_base) tags.

		Top: Top-most applied patch/commit
		Bottom: Bottom-most applied patch/commit
		Base: Commit on top of which the bottom most patch is applied

	Having these three tags, one can easily get the log/diff/other
	information only for commits that are (or are not!) part of the
	patch stack.

So far the few people (including myself for the past few months) I asked
privately, all said that they turn the feature off.

Ideas?  Comments?  Suggestions?

Josef 'Jeff' Sipek.

-- 
I think there is a world market for maybe five computers.
		- Thomas Watson, chairman of IBM, 1943.
