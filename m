Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbYJYVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbYJYVQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYJYVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:16:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbYJYVQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:16:36 -0400
Date: Sat, 25 Oct 2008 14:15:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
       eugene@ibrix.com, msnitzer@ibrix.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Re: ext3: fix ext3_dx_readdir hash collision handling
 - Regression
In-Reply-To: <20081025115631.GA17661@mit.edu>
Message-ID: <alpine.LFD.2.00.0810251414400.3327@nehalem.linux-foundation.org>
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu> <20081023063740.GA2438@gentoox2.trippelsdorf.de> <20081024000109.GD7842@mit.edu> <20081024042851.GA2360@gentoox2.trippelsdorf.de>
 <alpine.LFD.2.00.0810240853310.3287@nehalem.linux-foundation.org> <20081025115631.GA17661@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 25 Oct 2008, Theodore Tso wrote:
>
> I believe I've found the problem.

Your patch seems to fix it for me, so ack on that. Please do send a 
version with a sign-off when you're ok with it - otherwise I'll have to 
revert the old one..

		Linus
