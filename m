Return-Path: <linux-kernel-owner+w=401wt.eu-S1764671AbYFHL3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764671AbYFHL3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbYFHL3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:29:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53128 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759519AbYFHL3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:29:46 -0400
Date: Sun, 8 Jun 2008 13:30:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080608113028.GE10545@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org> <1212924004.32207.498.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212924004.32207.498.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 12:20:04PM +0100, David Woodhouse wrote:
> On Sun, 2008-06-08 at 11:47 +0200, Sam Ravnborg wrote:
> > +        $(MAKE) ARCH=$$arch SRCARCH=$$arch $(hdr-inst)=include \
> > +                BIASMDIR=-bi-$$arch ;\
> 
> We still use $(BIASMDIR) as a trigger to install into asm-$(ARCH)/
> instead of just to asm/, for 'headers_install_all'. But it's a fairly
> bad name now, since it doesn't do what it used to do.

Thanks.

I will name it ASMDIR and set it to 'y' if we shall install to asm/

	Sam
