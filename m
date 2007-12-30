Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXL3V2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXL3V2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXL3V2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:28:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57404 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbXL3V2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:28:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64
Date: Sun, 30 Dec 2007 22:48:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
References: <200712281353.37976.rjw@sisk.pl> <200712302204.56977.rjw@sisk.pl> <20071230205104.GB26120@elte.hu>
In-Reply-To: <20071230205104.GB26120@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712302248.03567.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 of December 2007, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > But i'm wondering - are we really ever resuming to a different 
> > > kernel version, for this to be an issue?
> > 
> > The boot kernel may be different from the kernel within the image, if 
> > that's what you're asking for.
> 
> how different can it be, for resume to work? I mean, we'll have deeply 
> kernel version dependent variables in RAM. Am i missing something 
> obvious?

On x86-64 it can be almost totally different (by restoring a hibernation image
we replace the entire contents of RAM with almost no constraints).

[Well, using a relocatable kernel for restoring an image with nonrelocatable one
or vice versa is rather not the best idea, but everything else should work in
theory.]

On i386 the boot kernel is still required to be the same as the one in the
image.

Greetings,
Rafael
