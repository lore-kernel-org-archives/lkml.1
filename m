Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZG3Jgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZG3Jgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZG3Jgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:36:54 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42923 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZG3Jgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:36:53 -0400
Date: Thu, 30 Jul 2009 11:36:53 +0200
From: Andreas Mohr <andim2@users.sourceforge.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roberto Oppedisano <roppedisano@infracomspa.it>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Re: drm:radeon_cp_idle/reset error storm, console lockup (-rc4 git)
Message-ID: <20090730093653.GA30007@rhlx01.hs-esslingen.de>
Reply-To: andi@lisas.de
References: <alpine.DEB.0.82.0809090914300.1221@skynet.skynet.ie> <20090730090005.GA4885@rhlx01.hs-esslingen.de> <21d7e9970907300221s3e63563dte184deb27a4703e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970907300221s3e63563dte184deb27a4703e2@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 30, 2009 at 07:21:59PM +1000, Dave Airlie wrote:
> > I'm throwing an uneducated guess that this log means that there's some locking-up drm inconsistency
> > during server crash shutdown (subsystem shutdown order violation?)
> > which is rendering my entire machine useless, including blocking tty access.
> 
> Pretty much X dies, tries to get the GPU driver to go back to text
> mode, this re-enters somewhere
> holding the drm lock and the GPU dies. Pretty much sums up the whole
> problem with graphics card
> drivers on Linux, I can't say how we can fix that apart from if you
> could gdb the X server and we
> can fix the actual crash so we can avoid the issue.

"avoid the issue"... "in _this_ particular problem case", you wanted to say
(picture Sisyphos :).

Ah, darn, I should have kept X running for some longer, or rather
directly presented gdb stuff such as backtrace, local environment etc.
I will handle this in a more flexible manner next time, however.

> The real fix for this sort of issues is called kernel modesetting.

...and I was almost ready to migrate to it already. ;)
Now strongly pondering whether I should.

> Dave.

Thank you for the fast reply!

Andreas Mohr
