Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbZJFThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbZJFThp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbZJFTho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:37:44 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:63464 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756818AbZJFTho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:37:44 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
Date: Tue, 6 Oct 2009 21:37:05 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, hohndel@infradead.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910061840.57681.elendil@planet.nl> <alpine.LFD.2.01.0910061132150.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910061132150.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062137.06593.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 19:37:07.0001 (UTC) FILETIME=[6376DA90:01CA46BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, you wrote:
> On Tue, 6 Oct 2009, Frans Pop wrote:
> > Enabling it by default somehow would be fine with me, but "compulsory"
> > is a step to far IMO. Users should always be allowed custom schemes.
>
> I do respect that - we shouldn't _force_ things if some people have
> special needs and do things differently and really need a very
> particular version number setup.

Note that I was referring to adding on the full commit identification. I 
have a lot less problems with the "+" (or whatever we end up with).

I would probably even use it, although it will mean that I effectively 
_always_ have the "+" because of local patches. But that is correct as 
with the patches it's no longer a vanilla release.

> That said, we might make it a lot harder for people to overlook this by
> mistake when they don't care or know enough. Maybe we can have three
> levels of the "automatic" version number, and make the third level ("no
> automatic sign of versioning at all") be something that you really need
> to ask for (eg you need to have EMBEDDED enabled to show that you want
> the whole extended config option setup or something fairly draconian
> like that).

I'd opt for the "or something" as I think it would be a mistake to link it 
to EMBEDDED. That has a rather different purpose.

One case to consider is distributions. They will have their own patches, 
possibly as a branch off mainline in git.
AFAICT with the current patch they'd automatically always get the "+", 
which is almost certain to conflict with their own naming schemes.
Distro configs with EMBEDDED set also does not seem right. Nor should it 
IMHO be needed to have to patch the Makefile to get rid of it.

I think just having a config option with the three choices you suggest and 
an appropriate help text to guide users should be sufficient, with the one 
that activates the "+" as default.

Cheers,
FJP
