Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbZJFPEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbZJFPEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZJFPEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:04:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:56137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZJFPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:04:29 -0400
Date: Tue, 6 Oct 2009 07:34:28 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lothar Wassmann <LW@karo-electronics.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] USB: isp1362: fix build warnings on 64-bit systems
Message-ID: <20091006143428.GA27158@kroah.com>
References: <1250046053-3097-1-git-send-email-vapier@gentoo.org> <20090813234410.GB4406@kroah.com> <8bd0f97a0908131734h2588d240k9000bace38b58e7f@mail.gmail.com> <8bd0f97a0910060132r1dd6b6a4u71eaa8763862aebd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0910060132r1dd6b6a4u71eaa8763862aebd@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 04:32:29AM -0400, Mike Frysinger wrote:
> On Thu, Aug 13, 2009 at 20:34, Mike Frysinger wrote:
> > On Thu, Aug 13, 2009 at 19:44, Greg KH wrote:
> >> On Tue, Aug 11, 2009 at 11:00:53PM -0400, Mike Frysinger wrote:
> >>> A bunch of places assumed pointers were 32-bits in size (bit checking and
> >>> debug output), but none of these affected runtime functionality.
> >>>
> >>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >>
> >> This patch doesn't apply to my tree, what did you make it against?
> >
> > it was reported against next, so i used that
> 
> so what tree do i need to use to get you to merge this ?  i'm guessing
> the semantic patch was what caused conflicts (my proposed patch
> already included that fix, but too late now).

Right now, just do it against Linus's tree, or 2.6.32-rc3 and I can
merge it.

thanks,

greg k-h
