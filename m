Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYJ1Akm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYJ1Akm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYJ1Akb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:40:31 -0400
Received: from kroah.org ([198.145.64.141]:36211 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751246AbYJ1Aka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:40:30 -0400
Date: Mon, 27 Oct 2008 17:27:18 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76_usb: update drivers/staging/at76_usb w/ mac80211
	port
Message-ID: <20081028002718.GA2992@kroah.com>
References: <1224877739-1586-1-git-send-email-linville@tuxdriver.com> <20081027185634.GA21649@kroah.com> <20081027211553.GH20389@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081027211553.GH20389@tuxdriver.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 05:15:53PM -0400, John W. Linville wrote:
> On Mon, Oct 27, 2008 at 11:56:34AM -0700, Greg KH wrote:
> > On Fri, Oct 24, 2008 at 03:48:59PM -0400, John W. Linville wrote:
> > > This updates drivers/staging/at76_usb to correspond with the latest
> > > version previously available in wireless-testing.
> > > 
> > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > 
> > I've applied this, but it does add the following warnings, which I don't
> > think you want to have:
> > 	drivers/staging/at76_usb/at76_usb.c:885: warning: ‘at76_set_associd’ defined but not used
> > 	drivers/staging/at76_usb/at76_usb.c:903: warning: ‘at76_set_listen_interval’ defined but not used
> > 	drivers/staging/at76_usb/at76_usb.c:989: warning: ‘at76_add_mac_address’ defined but not used
> > 
> > 
> > I'll remove these unused functions now from the in-kernel version.
> 
> Those were still there because Kalle had said he intended to use them.
> I see no need to carry them since you have them in git anyway.

Heh, fine, they are now gone, we can't add patches that add warnings :)

> > Is there any way to do development on this in the staging version now,
> > instead of the wireless-testing tree?
> 
> Fine with me, although I do have at least one patch for it that
> relates to a pending API change -- I just figured I'd wait for the
> round-trip of the patch above and then carry just that patch in my
> tree along with the mac80211 API changes that prompted it.  Any other
> development makes sense to go to your tree.

How about just sending that patch in when the api change goes in.  I
have no problem with other people sending in patches through their trees
that touch the staging directory for stuff like this, as it makes your
life much easier.

thanks,

greg k-h
