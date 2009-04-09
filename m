Return-Path: <linux-kernel-owner+w=401wt.eu-S934547AbZDISHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547AbZDISHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbZDISHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:07:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758849AbZDISHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:07:00 -0400
Date: Thu, 9 Apr 2009 11:04:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
In-Reply-To: <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904091056480.4583@localhost.localdomain>
References: <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Linus Torvalds wrote:
> 
> When the revolution comes, and the people who haven't converted to git get 
> sent to the gulags, we'll make "-M" the default.

Side note: in the meantime, if you know that you only work with the people 
who have already gone through the re-education program and will not need 
to be reported to the Office of non-Git Behavior Correction, you can add 
this to your ~/.gitconfig (or do it per-repository in .git/config if you 
work with lesser quality people on some of your stuff):

	[diff]
		renames

(or even "renames=copy" to get not just rename, but also copy-detection 
done automatically - but that can be quite a bit more expensive, and the 
upsides aren't as huge. But sometimes the copy detection is really very 
interesting, because it has occasionally found some really interesting 
patterns when people create new files).

[ Final note: I know, I know, my own release patches are done without -M. 

  It's horrible, and I feel bad about it every time, but the thing is, I 
  expect that people who actually want to download tar-balls and patches 
  to update their kernel are in the stone age, so I do those without 
  rename detection very much on purpose.

  So in this case do as I say, not as I do. ]

			Linus
