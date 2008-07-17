Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYGQHlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYGQHlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYGQHlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:41:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbYGQHlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:41:01 -0400
Date: Thu, 17 Jul 2008 00:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
Message-Id: <20080717003959.edf6531c.akpm@linux-foundation.org>
In-Reply-To: <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 00:25:41 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> This patch series introduces the "tracehook" interface layer of inlines
> in <linux/tracehook.h>.
>
> ...
>
>  25 files changed, 1084 insertions(+), 188 deletions(-)

It's a strange time to be sending this.

We're in the middle of a massive dump from linux-next into mainline and
soon we'll be doing a more modest dump of -mm into mainline and I'm
tiptoeing around getting all anxious when people try to sneak
wasnt-in-linux-next stuff into mainline thus wrecking all my junk.

I'm largely in ignore-new-stuff mode as I'm trying to stabilise
the existing stuff for 2.6.27-rc1 and hopefully the subsystem
maintainers are in the same mode.

So, hum.  It's not a good time for anyone to be merging new
probably-2.6.28 material like this!

So for now, please let's just review the code and if it does get decent
review and if there are no unresolveable objections, please ask Stephen
to include this tree in linux-next.


That being said, the impact on existing code is fairly modest and we
could perhaps slip it into 2.6.27-rc1.  I haven't looked at it yet.

Still.  Strange timing!
