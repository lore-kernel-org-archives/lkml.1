Return-Path: <linux-kernel-owner+w=401wt.eu-S965764AbXJQPzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965764AbXJQPzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935323AbXJQPzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:55:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935291AbXJQPzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:55:36 -0400
Date: Wed, 17 Oct 2007 08:55:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jaroslav Kysela <perex@perex.cz>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl
Subject: Re: suspicious ALSA empty commit
In-Reply-To: <Pine.LNX.4.61.0710170809580.11118@tm8103.perex-int.cz>
Message-ID: <alpine.LFD.0.999.0710170854280.26902@woody.linux-foundation.org>
References: <20071016.155044.82377336.davem@davemloft.net>
 <alpine.LFD.0.999.0710161624350.26902@woody.linux-foundation.org>
 <Pine.LNX.4.61.0710170809580.11118@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Jaroslav Kysela wrote:
> 
> I didn't notice, too. I've fixed this commit in my git tree.

More importantly, how did it get there in the first place?

As mentioned, normal git tools will not even *allow* you to create an 
empty commit by default! So you must be using some really strange workflow 
to get an empty commit, or be triggering a git bug, both of which should 
be resolved first.

		Linus
