Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZBDTxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZBDTxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZBDTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:53:32 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:50815 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZBDTxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:53:31 -0500
X-Spam-Hammy: 0.000-+--HTo:D*org, 0.000-+--HCc:D*org, 
	0.000-+--H*Ad:D*kernel.org
X-Spam-Spammy: 0.978-1--reload, 0.955-+--H*Ad:D*ffwll.ch, 
	0.942-+--H*r:mail.ffwll.ch
Date: Wed, 4 Feb 2009 20:53:24 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dri-devel@lists.sourceforge.net
Subject: Re: + drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu.patch
	added to -mm tree
Message-ID: <20090204195324.GA4548@viiv.ffwll.ch>
Mail-Followup-To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
	Dave Airlie <airlied@linux.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, dri-devel@lists.sourceforge.net
References: <200901292050.n0TKol5b015605@imap1.linux-foundation.org> <200901291324.17624.jbarnes@virtuousgeek.org> <20090129134825.620e3f84.akpm@linux-foundation.org> <20090131152508.GA4668@viiv.ffwll.ch> <20090202224448.b19eaca4.akpm@linux-foundation.org> <alpine.DEB.2.00.0902030955420.31073@skynet.skynet.ie> <20090204190357.7f252f64@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090204190357.7f252f64@neptune.home>
X-Operating-System: Linux viiv 2.6.29-rc3-00431-gf5c7dbe
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 07:03:57PM +0100, Bruno Prémont wrote:
> This patch does not work for me.
> With this patch applied kernel fails to read EDID data and discover
> proper modes. (It ends up displaying a picture looking like the BIOS
> bootup image). X fails to start finding no valid mode for LVDS output.

I've had the same problem (at least wrt to X), but it seems to disappear
when cold-booting. It even works when I boot with modeset=0, kill X, then
reload the i915 module with modeset=1. Maybe the kms is a bit flakey when
X played with it for too long beforehands.

But kernel modesetting for the framebuffer console always works, so
YMMV.

-Daniel
-- 
Daniel Vetter
E-Mail: daniel.vetter@ffwll.ch
Tel.: +41 (0)79 365 57 48
