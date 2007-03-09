Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbXCITA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbXCITA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbXCITA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:00:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60843 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXCITA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:00:56 -0500
Date: Fri, 9 Mar 2007 20:00:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Complain about missing system calls.
Message-ID: <20070309190051.GA20521@one.firstfloor.org>
References: <1173394873.3461.510.camel@pmac.infradead.org> <p737itqbdnl.fsf@bingen.suse.de> <20070309163805.GV18564@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309163805.GV18564@lug-owl.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Not everybody has a simple indexed list of pointers :)  For example,
> for vax-linux, we use a struct per syscall with the expected number of
> on-stack longwords for the call.
> 
> So if something "new" is coming up, please keep in mind that it should
> be flexible enough to represent that. :)

Are there plans to merge vax any time soon to mainline? 

Normally we don't care very much about out of tree code, especially
if it adds complexity like this.

But I suspect s390 would need number of arguments anyways.

-Andi
