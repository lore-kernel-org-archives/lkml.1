Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0CBKAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 05:00:13 -0500
Received: from coloquinte.cristau.org ([91.121.16.100]:55095 "EHLO
	coloquinte.cristau.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0CBKAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 05:00:11 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Mar 2010 05:00:11 EST
Date: Tue, 2 Mar 2010 10:52:15 +0100
From: Julien Cristau <jcristau@debian.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Kristian =?iso-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>,
       Arnd Bergmann <arnd@arndb.de>, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net, David Airlie <airlied@linux.ie>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DRM: fix headers_check warnings
Message-ID: <20100302095215.GW2927@patate.is-a-geek.org>
References: <1267262856.26906.12.camel@i7.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267262856.26906.12.camel@i7.satnam>
X-Operating-System: Linux 2.6.33-rc7-00001-g093998d i686
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 14:57:36 +0530, Jaswinder Singh Rajput wrote:

> 
> Fixed following headers_check warnings:
>   CHECK   include/drm (14 files)
>  include/drm/drm_mode.h:84: found __[us]{8,16,32,64} type without #include <linux/types.h>
>  include/drm/i915_drm.h:119: found __[us]{8,16,32,64} type without #include <linux/types.h>
>  include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
>  include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
>  include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
These files are shared with BSD, afaik, and they get the linux/types.h
include from drm.h.

Cheers,
Julien
