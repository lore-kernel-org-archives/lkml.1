Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbXKUDUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbXKUDUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 22:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXKUDUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 22:20:19 -0500
Received: from mail.fieldses.org ([66.93.2.214]:46366 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbXKUDUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 22:20:17 -0500
Date: Tue, 20 Nov 2007 22:20:09 -0500
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Petr Baudis <pasky@suse.cz>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: gitweb: kernel versions in the history (feature request,
	probably)
Message-ID: <20071121032009.GB4175@fieldses.org>
References: <20071120142042.GA4157@ff.dom.local> <20071120215904.GF1001@machine.or.cz> <47436E0F.6080003@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47436E0F.6080003@o2.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 12:30:23AM +0100, Jarek Poplawski wrote:
> I don't know git, but it seems, at least if done for web only, this
> shouldn't be so 'heavy'. It could be a 'simple' translation of commit
> date by querying a small database with kernel versions & dates.

If I create a commit in my linux working repo today, but Linus doesn't
merge it into his repository until after he releases 2.6.24, then my
commit will be created with an earlier date than 2.6.24, even though it
isn't included until 2.6.25.

So you have to actually examine the history graph to figure this out
this sort of thing.

--b.
