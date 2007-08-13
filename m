Return-Path: <linux-kernel-owner+w=401wt.eu-S1750726AbXHMP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750726AbXHMP3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973003AbXHMN1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:27:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S972998AbXHMN1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:27:03 -0400
Date: Mon, 13 Aug 2007 16:21:10 +0200
From: Andi Kleen <ak@suse.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [PATCH] x86: optionally show last exception from/to register contents
Message-ID: <20070813142110.GC3406@bingen.suse.de>
References: <46C05D91.76E4.0078.0@novell.com> <20070813130845.GA3406@bingen.suse.de> <46C0751E.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C0751E.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I though you did, but since I never saw it appear in any release, I posted
> this one...

It's a little different (and somewhat hackish I admit) 
ftp://firstfloor.org/pub/ak/x86_64/debug/last-branch
It has far more overhead than yours of course.

The only way to merge something like that would be dynamic
patching and I was never quite motivated for that.

> So especially with the first concern of yours - is it worth at all rev-ing this
> patch to address the other change requests you voiced?

The patch is useful even with the race, just document somewhere
that it is unreliable (perhaps in the printk itself) and do the
other changes.

I would also suggest to enable it by default.

-Andi
