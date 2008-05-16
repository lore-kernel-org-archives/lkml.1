Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbYEPUWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbYEPUWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYEPUWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:22:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59174 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYEPUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:22:23 -0400
Date: Fri, 16 May 2008 22:22:28 +0200
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ondrej Zajicek <santiago@crfreenet.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>, JosephChan@via.com.tw,
       akpm@linux-foundation.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver - Resend
Message-ID: <20080516202228.GA15817@skynet.be>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67745@exchtp03.taipei.via.com.tw> <20080507184333.7d0f1bf4.krzysztof.h1@poczta.fm> <20080508081508.GD11121@localhost.localdomain> <Pine.LNX.4.64.0805081452120.8604@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805081452120.8604@anakin>
User-Agent: Mutt/1.5.9i
From: Luc Verhaegen <libv@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 02:52:34PM +0200, Geert Uytterhoeven wrote:
> On Thu, 8 May 2008, Ondrej Zajicek wrote:
> > On Wed, May 07, 2008 at 06:43:33PM +0200, Krzysztof Helt wrote:
> > > PS. I assume that your driver will replace the existing vt8623fb (CLE266?) driver when ready. Am I right?
> > 
> > These drivers are hardly comparable. vt8623fb supports CLE266 with VGA output only,
> > but allows arbitrary resolutions and pixclocks, high-res text mode and
> > (partially) suspend/resume. viafb implements fixed resolutions only and
> > have no text mode and no suspend/resume support (according to my quick
> > look on it).
> 
> It's a pity viafb implements fixed resolutions only. Is there any
> specific reason for that?
> 
> Gr{oetje,eeting}s,
> 
> 						Geert

Known good dotclock parameters versus a routine to generate stable dotclocks
parameters.

Luc Verhaegen.
SUSE/Novell X Driver Developer.
