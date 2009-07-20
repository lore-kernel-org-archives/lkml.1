Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbZGTOkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbZGTOkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZGTOkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:40:22 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55181 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZGTOkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:40:22 -0400
Date: Mon, 20 Jul 2009 23:39:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] Restructure BSS linker script macros.
Message-ID: <20090720143944.GA29422@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Anders Kaseorg <andersk@ksplice.com>
References: <alpine.DEB.1.10.0907121820360.23364@vinegar-pot.mit.edu> <20090716203432.GB6096@merkur.ravnborg.org> <alpine.DEB.1.10.0907161636090.6798@vinegar-pot.mit.edu> <alpine.DEB.1.10.0907161841210.6798@vinegar-pot.mit.edu> <20090717221336.GA7336@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717221336.GA7336@merkur.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 12:13:36AM +0200, Sam Ravnborg wrote:
> On Thu, Jul 16, 2009 at 06:58:50PM -0400, Tim Abbott wrote:
> > On Thu, 16 Jul 2009, Tim Abbott wrote:
> > 
> > > On Thu, 16 Jul 2009, Sam Ravnborg wrote:
> > > 
> > > > On Sun, Jul 12, 2009 at 06:23:33PM -0400, Tim Abbott wrote:
> > > > > I'd like acks from Sam and David on this one.  Also CCing Paul, since
> > > > > he has a patch from me which will need to be updated to use
> > > > > BSS_SECTION(0, PAGE_SIZE, 4) once this gets merged.
> > [...]
> > > > Could you please resend including the necessary fix for mn10300 so we do not
> > > > break bisecting.
> > > 
> > > I don't understand what you're asking here.  The original patch I sent 
> > > does include the necessary fix for mn10300 in the first hunk (reproduced 
> > > below).  I intentionally changed the mn10300 use at the same time as 
> > > changing the macros in order to avoid breaking bisecting.
> > 
> > I realized that you probably meant that I should resend the sh patch that 
> > I have currently in linux-next via Paul's tree that is broken by this 
> > change.
> > 
> > Paul -- the patch below differs from the version have in two ways:
> > (1) I updated it to use the fixed BSS linker script macros from this 
> > thread.
> > (2) I dropped the hunk that conflicted with a similar change in the percpu 
> > tree[2], as the version of that change in the percpu tree is better.
> 
> I do not expect Tejun's work to be included until next merge window.
> It would be nice if we could queue up a lot of vmlinux.lds
> cleanup patches so they are ready for next merge window.
> But we should rely on the arch maintainers mostly - as you nicely
> have done for sh here.
> 
I've pulled your kbuild-fixes.git in to a topic branch with Tim's
BSS_SECTION fix applied over top of it, this seemed like the easiest way
to keep my tree building both in and out of -next. Once kbuild-fixes hits
Linus's tree it should all sort itself out anyways.
