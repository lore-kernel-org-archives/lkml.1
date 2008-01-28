Return-Path: <linux-kernel-owner+w=401wt.eu-S1751538AbYA1XXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbYA1XXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764440AbYA1XPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:15:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:52699 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764586AbYA1XPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:15:33 -0500
Date: Mon, 28 Jan 2008 15:10:06 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 108/196] Kobject: change net/bridge to use
	kobject_create_and_add
Message-ID: <20080128231006.GA5292@suse.de>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-29-git-send-email-gregkh@suse.de> <20080125081923.22425d36@deepthought> <20080125174552.GA4242@suse.de> <Pine.LNX.4.64.0801282309070.1185@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801282309070.1185@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 11:09:24PM +0100, Jan Engelhardt wrote:
> 
> On Jan 25 2008 09:45, Greg KH wrote:
> >> 
> >> Okay, but where is the new kobject freed?
> >
> >In the call to kobject_unregister(), which has then later in the series
> >been converted to a call to kobject_put().
> >
> Hm, working on LDD 3.1? :-)

No, unfortunatly :(

Actually, the documentation that was written in this patch series, would
be good to replace the existing kobject documentation in LDD 3.  But
it's a bit hard to just replace a chapter at a time in a book that is
already published, we really don't have the mechanism in place for such
a thing...

thanks,

greg k-h
