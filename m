Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYBDSQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYBDSQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYBDSQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:16:00 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:15594 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYBDSP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:15:59 -0500
X-SBRS: None
X-MesageID: 40561706
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,303,1199682000"; 
   d="scan'208";a="40561706"
Date: Mon, 4 Feb 2008 18:15:12 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <greg@kroah.com>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Basic braille screen reader support
Message-ID: <20080204181512.GR5205@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <greg@kroah.com>, torvalds@osdl.org,
	linux-kernel@vger.kernel.org
References: <20080204031842.GE4439@implementation> <20080204171008.GA22050@kroah.com> <20080204172441.GP5205@implementation.uk.xensource.com> <20080204180617.GA22656@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080204180617.GA22656@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH, le Mon 04 Feb 2008 10:06:17 -0800, a écrit :
> > However, they share the same low-level primitives: the recently added
> > keyboard and vc notifiers, screen_glyph(), inverse_translate(),
> > kd_mksound, etc.
> 
> I guess I'm worried that the hooks that you add here will not be usable
> by speakup, and we'll have to add more in places close to this, but not
> quite the same.

Actually, speakup already just use these and no others.

> I know speaking and "showing" are two different things, but they both
> require the same data flow going into them in order to achieve their
> goals, I just don't want to see this work being done without considering
> both needs.

I _am_ considering both needs.  Actually, most of the recent commits to
SpeakUp are mines :)

> But, if you feel that both will work properly with these limited
> exports, I have no objections.

They already both do :)

Samuel
