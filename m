Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYKJReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYKJReq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYKJRei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:34:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbYKJReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:34:37 -0500
Date: Mon, 10 Nov 2008 09:34:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] C99 initializers for DEFINE_RATELIMIT_STATE()
In-Reply-To: <20081110093026.fe4bf90e.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0811100932500.3468@nehalem.linux-foundation.org>
References: <200811042114.48495.bart.vanassche@gmail.com> <e2e108260811100443j18a6353cj8d47ee3f1f8bec1@mail.gmail.com> <20081110091602.d5709c12.randy.dunlap@oracle.com> <20081110093026.fe4bf90e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Nov 2008, Andrew Morton wrote:
> 
> I already have a patch queued which does this
> (linux-ratelimith-fixed-missing-initializer-warning.patch).  I sent it
> to Linus on October 29 and he did not apply it, so I parked it for 2.6.29.

I just don't see the point of the patch at all. It doesn't fix anything, 
and it just makes the code bigger and uglier. We have tons of other 
simple initializers that aren't C99, and we're not going to convert them 
either. 

		Linus
