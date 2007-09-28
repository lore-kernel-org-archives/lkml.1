Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbXI1Mub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbXI1Mub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 08:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbXI1MuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 08:50:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46590 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbXI1MuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 08:50:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More E820 brokenness
Date: Fri, 28 Sep 2007 15:05:01 +0200
User-Agent: KMail/1.9.5
Cc: Jordan Crouse <jordan.crouse@amd.com>, jkeating@redhat.com,
       Joerg Pommnitz <pommnitz@yahoo.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
References: <46FC2BFD.6070200@zytor.com> <20070927235427.GA18900@cosmic.amd.com> <46FC46E3.5020508@zytor.com>
In-Reply-To: <46FC46E3.5020508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281505.02542.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 September 2007 02:12, H. Peter Anvin wrote:
> Jordan Crouse wrote:
> > 
> > Worked, but that just raises more questions.  Why didn't more x86 boxes
> > break or, alternatively, why did a new version of the BIOS fix the problem? 
> > I guess we shouldn't look a gift horse in the mouth. Or something.
> > 
> 
> Why didn't more x86 boxes break... well, it's pretty natural an
> implementation of the BIOS to not clobber registers that aren't outputs.
>  Arguably the BIOSes that do are still buggy, since there isn't a
> well-defined calling sequence for the BIOS and the convention that has
> evolved is "don't clobber anything unless it's an output."
> 
> It's still wrong, however, especially since it means omitting the *real*
> SMAP check.

I'd like to update http://bugzilla.kernel.org/show_bug.cgi?id=9086 with correct
information.

Should I add a pointer to the patch from your previous message to it?

Greetings,
Rafael
