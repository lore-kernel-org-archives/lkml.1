Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbXBKFuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbXBKFuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 00:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXBKFuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 00:50:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42040 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbXBKFuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 00:50:19 -0500
Date: Sun, 11 Feb 2007 05:50:15 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Christopher Li <sparse@chrisli.org>
Cc: Andi Kleen <ak@suse.de>, linux-sparse@vger.kernel.org,
       linux kernel mail list <linux-kernel@vger.kernel.org>,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: [ANNOUNCE] sparse-0.2-cl2 is now available
Message-ID: <20070211055015.GR10050@ftp.linux.org.uk>
References: <20070204085329.GA6520@chrisli.org> <20070210000055.GA19968@chrisli.org> <p73hctthq8q.fsf@bingen.suse.de> <20070211051758.GA2113@chrisli.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211051758.GA2113@chrisli.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 09:17:58PM -0800, Christopher Li wrote:
> e.g. sparse has not way to know some function only get called with interrupt
> disabled (or some lock already hold). So it assume interrupt is still
> enable and generate wrong warnings. Another example is that some helper
> function will wrap the locking function. Complain about the exit with locking
> hold is wrong.
> 
> I am hoping adding the cross function checking will reduce those false positive.
> Any way, it need more information to reduce false positive.
> 
> I am still working on the cross function checking. May be it will become
> more useful one day.

I have some stuff in that direction, but it take some resurrecting...
