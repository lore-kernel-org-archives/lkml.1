Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYFLAZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYFLAZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYFLAZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:25:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbYFLAZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:25:30 -0400
Date: Wed, 11 Jun 2008 17:24:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.26-rc5
In-Reply-To: <alpine.LFD.1.10.0806111942510.12191@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0806111718240.3101@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806111942510.12191@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jun 2008, Len Brown wrote:
> 
>  27 files changed, 255 insertions(+), 180 deletions(-)

Hmm. I get very different statistics:

 27 files changed, 434 insertions(+), 359 deletions(-)

You seem to use "git diff -w" to ignore whitespace changes, which explains 
it, but please don't - it makes it harder to compare with expected 
results, and it hides some changes entirely.

I do agree that using '-w' is often useful, but especially for the purpose 
of letting people know what changed it kind of avoids the point by hiding 
many things.

		Linus
