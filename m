Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbZJMRwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbZJMRwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760778AbZJMRwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:52:39 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:62360 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760764AbZJMRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:52:38 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Date: Tue, 13 Oct 2009 19:51:59 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910130004.46388.elendil@planet.nl> <20091013070505.GC31483@elte.hu>
In-Reply-To: <20091013070505.GC31483@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910131952.01209.elendil@planet.nl>
X-OriginalArrivalTime: 13 Oct 2009 17:52:02.0039 (UTC) FILETIME=[DE4E4070:01CA4C2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Ingo Molnar wrote:
> > IMO both LOCALVERSION_AUTO *and* the added "+" can be unsuitable for
> > some use cases, for example for distributions.
> >
> > If someone uses git to manage their custom patches, the only out this
> > patch leaves them to avoid the "+" is to revert it in their own trees.
>
> Is this a bad thing?

IMHO yes. This change essentially creates a backwards incompatibility with 
existing naming schemes. Requiring to patch the change out to preserve an 
existing naming scheme just seems a tad unfriendly.

But if I'm the only one who feels that way, go right ahead. You might 
consider adding a comment in the Makefile as a pointer though.

I appreciate that you want this to be a strong default. Does Kconfig 
support defining an option that can only be set by manually editing the 
config and is not displayed as a config question?
If that is supported (or if support for that could be added), then that 
might be a sufficiently obscure solution that experts would know how to 
find, but would leave the vast majority of users using the default.

Cheers,
FJP
