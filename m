Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbZGQWGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbZGQWGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZGQWGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:06:06 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36384 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbZGQWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:06:05 -0400
Date: Sat, 18 Jul 2009 00:06:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
Message-ID: <20090717220603.GA7321@merkur.ravnborg.org>
Mail-Followup-To: Tim Abbott <tabbott@ksplice.com>,
	Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Anders Kaseorg <andersk@ksplice.com>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu> <20090716203432.GB6096@merkur.ravnborg.org> <alpine.DEB.1.10.0907161636090.6798@vinegar-pot.mit.edu> <alpine.DEB.1.10.0907161841210.6798@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0907161841210.6798@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 06:58:50PM -0400, Tim Abbott wrote:
> On Thu, 16 Jul 2009, Tim Abbott wrote:
> 
> > On Thu, 16 Jul 2009, Sam Ravnborg wrote:
> > 
> > > On Sun, Jul 12, 2009 at 06:23:33PM -0400, Tim Abbott wrote:
> > > > I'd like acks from Sam and David on this one.  Also CCing Paul, since
> > > > he has a patch from me which will need to be updated to use
> > > > BSS_SECTION(0, PAGE_SIZE, 4) once this gets merged.
> [...]
> > > Could you please resend including the necessary fix for mn10300 so we do not
> > > break bisecting.
> > 
> > I don't understand what you're asking here.  The original patch I sent 
> > does include the necessary fix for mn10300 in the first hunk (reproduced 
> > below).  I intentionally changed the mn10300 use at the same time as 
> > changing the macros in order to avoid breaking bisecting.
> 
> I realized that you probably meant that I should resend the sh patch that 
> I have currently in linux-next via Paul's tree that is broken by this 
> change.

No - I simply overlooked that you already had included
the mn10300 fix.

So I have applied your patch to kbuid-fixes.git.

I will push to Linus after some air-time in -next.

	Sam
