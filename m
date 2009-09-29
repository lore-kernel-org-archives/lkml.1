Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZI2JRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZI2JRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZI2JRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:17:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:34748 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZI2JRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:17:02 -0400
Date: Tue, 29 Sep 2009 11:17:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dirk Hohndel <hohndel@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial fix of a very frequent spelling mistake
In-Reply-To: <20090929014357.GA3597@bombadil.infradead.org>
Message-ID: <alpine.LSU.2.00.0909291115110.9280@wotan.suse.de>
References: <20090929014357.GA3597@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009, Dirk Hohndel wrote:

> something-bility is spelled as something-blity
> so a grep for 'blit' would find these lines
> 
> this is so trivial that I didn't split it by subsystem / copy 
> additional maintainers - all changes are to comments
> The only purpose is to get fewer false positives when grepping
> around the kernel sources.

I will split out the drivers/staging part and forward it to Greg (*) and 
apply the rest to trivial queue.

(*) I try to avoid merging the trivial changes to staging drivers, as 
these are usually being changed/rewritten quite heavily and we'd get a lot 
of unnecessary conflicts in -next.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
