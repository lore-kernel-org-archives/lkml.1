Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbZDIRdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbZDIRdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZDIRdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:33:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792AbZDIRdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:33:24 -0400
Date: Thu, 9 Apr 2009 10:30:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-am33-list@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MN10300: Move to arch/mn10300/include/asm/
In-Reply-To: <20090409171447.3119.48356.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.0904091028080.4583@localhost.localdomain>
References: <20090409171447.3119.48356.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, David Howells wrote:
>
> Move arch headers from include/asm-mn10300/ to arch/mn10300/include/asm/.

This patch looks broken.

It doesn't "move" anything at all. It just copies things, and leaves the 
old files alone.

I wonder if you created the diff by doing

	git diff arch/mn10300

because you had other changes pending that you didn't want to include?

Regardless, I'm not applying something this obviously broken.

		Linus
