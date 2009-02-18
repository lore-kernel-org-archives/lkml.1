Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZBRR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZBRR0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZBRR0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:26:04 -0500
Received: from cmpxchg.org ([85.214.51.133]:44447 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZBRR0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:26:03 -0500
Date: Wed, 18 Feb 2009 18:28:02 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] documentation: update CodingStyle tips for Emacs users
Message-ID: <20090218172802.GA1823@cmpxchg.org>
References: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan> <1234948770.23768.25.camel@ecld0pohly> <20090218095931.GA2054@cmpxchg.org> <1234952639.23768.32.camel@ecld0pohly>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234952639.23768.32.camel@ecld0pohly>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 11:23:59AM +0100, Patrick Ohly wrote:
> On Wed, 2009-02-18 at 09:59 +0000, Johannes Weiner wrote:
> [formatting of line continuation in argument list]
> > Unfortunately, this seems to depend on the maintainer.  Both styles
> > are used all over the kernel but Documentation/CodingStyle and
> > scripts/checkpatch.pl prefer what the above emacs configuration does.
> 
> checkpatch.pl didn't seem to mind either way. I haven't seen this
> particular aspect mentioned in the CodingStyle either.

This is from CodingStyle:

	Outside of comments, documentation and except in Kconfig,
	spaces are never used for indentation, and the above example
	is deliberately broken.

> > I doubt that people do tab tab tab space space space space space by
> > hand, so I strongly suspect that the tab-only zealots don't use emacs
> > which does this adjustment automatically.
> > 
> > You should probably add linux-davem to the above or something.  Or
> > name the coding style after the text-editor the target maintainer
> > uses :-)
> 
> One could also get really fancy and extend the path matching to pick the
> right style depending on the subdirectory ;-)
> 
> Thanks for the clarification. In the future I'll pay closer attention to
> existing code and turn the macro on or off accordingly.

That's probably the best way to judge such details, agreed.  Integrate
well with the surrounding code.

	Hannes
