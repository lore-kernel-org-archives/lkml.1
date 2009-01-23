Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbZAWATj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbZAWATj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZAWAT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:19:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbZAWAT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:19:28 -0500
Date: Thu, 22 Jan 2009 16:16:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: gregkh@suse.de, mingo@elte.hu, geert@linux-m68k.org, joern@logfs.org,
       lkml@davidb.org, kernel@linuxace.com, kay.sievers@vrfy.org,
       phillip@lougher.demon.co.uk, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-Id: <20090122161659.53de9e56.akpm@linux-foundation.org>
In-Reply-To: <20090122215041.GA29369@redhat.com>
References: <20090109165422.GF24884@logfs.org>
	<20090109193738.GA9827@linode.davidb.org>
	<20090109211937.GA14342@logfs.org>
	<20090110124335.GB30744@elte.hu>
	<20090110165033.GA23943@logfs.org>
	<20090110101235.7ca24c44.akpm@linux-foundation.org>
	<20090110221528.GA31774@elte.hu>
	<Pine.LNX.4.64.0901111022590.30201@anakin>
	<20090111153920.GC7401@elte.hu>
	<20090111163018.GA9300@suse.de>
	<20090122215041.GA29369@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Jan 2009 16:50:41 -0500 Dave Jones <davej@redhat.com> wrote:
> I don't mean to piss on your parade, but from my viewpoint, staging
> is a trainwreck so far, and I'd hate to see it get worse.

I must say that I have intense "wtf were we thinking of" moments each time
something in staging/ sticks an ugly head out of its cave.

My question is: what is the process for moving things out of staging/ and
into the kernel proper?  We don't want to be merging ex-crap code which has
had its whitespace and wrappers cleaned up by a person who is not suitably
experienced in the relevant subsystem.

It _should_ (I think) be "OK, this is ready for us to start reviewing". 
ie: treat it as if it had just come in from a random new submitter.

a) If that happens, who will be responding to the review comments?  Who
   was the submitter?

b) What happens if it is then decided that we just don't want that code
   in the tree at all?

c) Has any code yet made the transition out of staging and into the
   kernel proper?  If so, which?

