Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYCJU0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYCJU0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbYCJUY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:24:59 -0400
Received: from mail.queued.net ([207.210.101.209]:2895 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834AbYCJUY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:24:57 -0400
Date: Mon, 10 Mar 2008 16:28:44 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: Re: [PATCH 3/6] gxfb: move MSR bit fields into gxfb.h
Message-ID: <20080310162844.6e8e9215@ephemeral>
In-Reply-To: <20080310131432.e4567537.akpm@linux-foundation.org>
References: <20080308204840.47a27236@ephemeral>
	<20080310131432.e4567537.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 13:14:32 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 8 Mar 2008 20:48:40 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > >From bee7242cf04c4a060b311b11985efb495f308355 Mon Sep 17 00:00:00 2001
> > From: Andres Salomon <dilinger@debian.org>
> > Date: Mon, 25 Feb 2008 15:29:36 -0500
> > Subject: [PATCH] gxfb: move MSR bit fields into gxfb.h
> > 
> > This continues the gxfb header cleanups.  MSRs are defined in geode.h;
> > the specific bits we care about are defined in gxfb.h.
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > ---
> >  drivers/video/geode/display_gx.h |    3 ---
> >  drivers/video/geode/gxfb.h       |   16 ++++++++++++++++
> >  drivers/video/geode/gxfb_core.c  |    2 +-
> >  drivers/video/geode/video_gx.c   |    4 ++--
> >  drivers/video/geode/video_gx.h   |   14 --------------
> >  5 files changed, 19 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/video/geode/display_gx.h b/drivers/video/geode/display_gx.h
> > index 56e9d2e..ad556d3 100644
> > --- a/drivers/video/geode/display_gx.h
> > +++ b/drivers/video/geode/display_gx.h
> > @@ -16,7 +16,4 @@ int gx_line_delta(int xres, int bpp);
> >  
> >  extern struct geode_dc_ops gx_dc_ops;
> >  
> > -/* MSR that tells us if a TFT or CRT is attached */
> > -#define GLD_MSR_CONFIG_DM_FP 0x40
> > -
> >  #endif /* !__DISPLAY_GX1_H__ */
> 
> Something has gone wrong here.  The code in current mainline is
> 
> 
> 
> extern struct geode_dc_ops gx_dc_ops;
> 
> /* MSR that tells us if a TFT or CRT is attached */
> #define GLD_MSR_CONFIG   0xC0002001
> #define GLD_MSR_CONFIG_DM_FP 0x40
> 
> /* Display controller registers */
> 
> 
> whereas you're patching something else.
> 
> 
> In [1/6] you refer to "the MSR cleanup patch".  I don't know what that is.
> 

That would be this:

http://thread.gmane.org/gmane.linux.kernel/645387/focus=645636


> 
> Please clean up the changelogs - remove those email headers from the
> email-forwarding operation and remove the additional little commentary on
> top: if there's actually anything in there which is needed then it should
> be integrated into the changelog proper, thanks.
> 

For future requests, or should I resend these to you?
