Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbXDPG1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbXDPG1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXDPG1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:27:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34260 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbXDPG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:27:12 -0400
Date: Mon, 16 Apr 2007 08:27:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [AppArmor 39/41] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070416062708.GA14641@one.firstfloor.org>
References: <20070412090809.917795000@suse.de> <20070412090849.465428000@suse.de> <p733b35903l.fsf@bingen.suse.de> <200704151621.52906.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704151621.52906.agruen@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's nice to check for consistency though, so we're adding that. Profile 
> loading is a trusted operation, at least so far, and so security wise we 
> don't actually have to care --- if loading an invalid profile can bring down 
> the system, then that's no worse than an arbitrary module that crashes the 
> machine. Not sure if there will ever be user loadable profiles; at least at 
> that point we had to care.

A security system that allows to crash the kernel is a little weird 
though. It would be better to check. Not that a recursion check
is particularly expensive.

-Andi
