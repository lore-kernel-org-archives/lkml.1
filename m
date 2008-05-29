Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYE2HdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYE2HdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYE2Hcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:32:52 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48684 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbYE2Hcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:32:51 -0400
Date: Thu, 29 May 2008 09:33:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Airlie <airlied@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: Re: in-kernel DRM tree move around....
Message-ID: <20080529073331.GA12129@uranus.ravnborg.org>
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com> <20080529042335.GA10636@uranus.ravnborg.org> <21d7e9970805282223i75cb37f8v4883454c08b2ba6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970805282223i75cb37f8v4883454c08b2ba6e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Makefie bits:
> > 5 EXTRA_CFLAGS = -Iinclude/drm
> > Use ccflags-y :=  -Iinclude/drm
> > I assume this is a temporary workaround and you plan to fix
> > up all includes to use "#include <drm/fo.h>"
> 
> I'd rather not do that due the fact that a lot of these files are
> shared with other OSes upstream and I'd rather not diverge too far but
> maybe later.
Understood.

To be sure you did not miss it...
At least change EXTRA_CFLAGS to ccflags-y.

	Sam
