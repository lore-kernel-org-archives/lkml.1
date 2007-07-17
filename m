Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbXGQPN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbXGQPN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXGQPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:13:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45853 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbXGQPNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:13:19 -0400
Date: Tue, 17 Jul 2007 17:14:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Domen Puncer <domen.puncer@telargo.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce __init_exit function annotation
Message-ID: <20070717151432.GA25939@uranus.ravnborg.org>
References: <20070717080248.GK4375@moe.telargo.com> <20070717130230.GB24780@uranus.ravnborg.org> <s5htzs3ulpf.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htzs3ulpf.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 04:52:12PM +0200, Takashi Iwai wrote:
> At Tue, 17 Jul 2007 15:02:30 +0200,
> Sam Ravnborg wrote:
> > 
> > On Tue, Jul 17, 2007 at 10:02:48AM +0200, Domen Puncer wrote:
> > > Introduce __init_exit, which is useful ie. for drivers that call
> > > cleanup functions when they fail in __init functions.
> > 
> > This is wrong.
> > On arm (just one example of several) the __exit section are discarded
> > at buildtime so any reference from __init to __exit will cause the
> > linker to error out.
> 
> Hmm, from what I see, it adds __init to the function.  There is no
> reference to __exit.

The cleanup functions are marked __exit in the referenced case.

	Sam
