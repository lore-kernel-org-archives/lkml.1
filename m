Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbZDIWEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbZDIWEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbZDIWD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:03:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105AbZDIWD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:03:56 -0400
Date: Thu, 9 Apr 2009 15:00:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: catalin.marinas@arm.com, akpm@linux-foundation.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
In-Reply-To: <12327.1239313897@redhat.com>
Message-ID: <alpine.LFD.2.00.0904091458330.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091412060.4583@localhost.localdomain> <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk>
 <11730.1239311156@redhat.com> <12327.1239313897@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, David Howells wrote:
> 
> Is there a way to get git-diff to produce just the stats and summary and not
> the body of the patch?

Sure. "git diff --stat --summary" should do it.

But it does look like stg is being silly, and using "git apply" to 
generate a diffstat, instead of just asking for it to begin with. I guess 
it goes back to some really old days (2005) when that "--stat" wasn't tied 
into the whole git diff logic.

			Linus
