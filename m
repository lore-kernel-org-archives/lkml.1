Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbXHWLaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbXHWLaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbXHWLai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:30:38 -0400
Received: from iona.labri.fr ([147.210.8.143]:33070 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXHWLah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:30:37 -0400
Date: Thu, 23 Aug 2007 13:30:35 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Console events and accessibility
Message-ID: <20070823113035.GD3287@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070821212939.GD3658@interface.famille.thibault.fr> <20070822054855.GB23336@kroah.com> <20070822085355.GB3359@implementation.labri.fr> <20070822130520.GE3359@implementation.labri.fr> <20070823100402.GB6742@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070823100402.GB6742@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH, le Thu 23 Aug 2007 03:04:02 -0700, a écrit :
> > I mean: yes, with these three patches, speakup will work fine.
> 
> 3 patches?  I only saw 2.  Or do you mean the modifications of the 3
> files?

Maybe you missed the keyboard notification patch which is already in
-mm.

> The patches look sane but you should change the global symbols to play
> nicer in the namespace.  Care to respin them together with this change?

You mean inverse_translate and screen_glyph?

> > The biggest change we'll have to do in speakup is the way it accesses
> > the serial port, which is really dirty for now, but that's an internal
> > matter.
> 
> Yeah, that shouldn't be that tough to do.

Well, the biggest problem is that we'd like to output on serial _before_
/dev gets mounted.

> It doesn't look like these changes handle scrolling of the console, do
> they?

Ah, indeed, speakup doesn't seem to handle it, that's why I forgot it in
the patch.  I'll see what needs to be done.

Thanks,
Samuel
