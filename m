Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbYBETgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbYBETgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbYBETgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:36:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYBETgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:36:13 -0500
Date: Tue, 5 Feb 2008 21:11:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ross Vandegrift <ross@kallisti.us>
Cc: Glenn Griffin <ggriffin.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
Message-ID: <20080205201106.GB26150@one.firstfloor.org>
References: <47a79d64.16538c0a.5b6a.ffffb0fe@mx.google.com> <20080205155558.GA23145@one.firstfloor.org> <c9e534200802051029u5d08cf6dm54866f769e362262@mail.gmail.com> <20080205192559.GA10573@kallisti.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205192559.GA10573@kallisti.us>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that any reasonably recent PC can generate enough
> forged SYN packets to overwhelm reasonable SYN queues on a much more
> powerful server.

Have you actually seen this with a recent kernel in the wild or are
you just talking theoretically?

Linux uses some heuristics to manage the syn queue that should
still ensure reasonable service even without cookies under attack.
Also SYN-RECV sockets are stored in a special data structure optimized
to use minimal resources.

It is far from the classical head drop method that was so vunerable
to syn flooding.

-Andi
