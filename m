Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYFRQ6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYFRQ6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYFRQ6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:58:36 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34177 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbYFRQ6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:58:35 -0400
Date: Wed, 18 Jun 2008 18:59:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080618165918.GA24283@uranus.ravnborg.org>
References: <20080610190307.GA15983@uranus.ravnborg.org> <20080611154816.GA8167@c2.user-mode-linux.org> <20080612180859.GA2271@uranus.ravnborg.org> <20080612201315.GA10879@c2.user-mode-linux.org> <20080612210615.GA7558@uranus.ravnborg.org> <4852FDFC.1020403@googlemail.com> <20080618165138.GD8225@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618165138.GD8225@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 12:51:38PM -0400, Jeff Dike wrote:
> On Sat, Jun 14, 2008 at 01:08:44AM +0200, Gabriel C wrote:
> > Another thing I noticed is this hunk :
> > 
> > +$(shell $(CC) -print-file-name=ld-linux.so.2) \
> > 
> > On 64bit that should not work since it is ld-linux-x86-64.so.2 and not ld-linux.so.2
> 
> That's a good point too.
> 
> This seems like an awful lot of fragile hair to go through in order to
> avoid using gcc to drive the link.

I agree on that. I have pulled the patch from kbuild-next.git,
and it will return only when I have found a simple way to handle um.
I think it is easy to do but I have not looked at it yet.

	Sam
