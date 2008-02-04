Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbYBDRZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbYBDRZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbYBDRZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:25:32 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:4112 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbYBDRZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:25:30 -0500
X-SBRS: None
X-MesageID: 40553549
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,303,1199682000"; 
   d="scan'208";a="40553549"
Date: Mon, 4 Feb 2008 17:24:41 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <greg@kroah.com>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Basic braille screen reader support
Message-ID: <20080204172441.GP5205@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <greg@kroah.com>, torvalds@osdl.org,
	linux-kernel@vger.kernel.org
References: <20080204031842.GE4439@implementation> <20080204171008.GA22050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080204171008.GA22050@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Greg KH, le Mon 04 Feb 2008 09:10:08 -0800, a écrit :
> On Mon, Feb 04, 2008 at 03:18:43AM +0000, Samuel Thibault wrote:
> > This adds a minimalistic braille screen reader support.
> > This is meant to be used by blind people e.g. on boot failures or when /
> > cannot be mounted etc and thus the userland screen readers can not work.
> 
> Will this api work with the SpeakUp kernel drivers?  Are the hooks
> sufficient for what those drivers are expecting?

SpeakUp and this are quite independant (though they will probably both
end up in the drivers/a11y/ directory), at least just because the way
they review the screen is very different.  Speech synthesis' matter is
the time to say things, while braille's matter is the space to show
things.

However, they share the same low-level primitives: the recently added
keyboard and vc notifiers, screen_glyph(), inverse_translate(),
kd_mksound, etc.

> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org
> 
> You forgot a trailing '>'  :)

Ergl :)

Samuel
