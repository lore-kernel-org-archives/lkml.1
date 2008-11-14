Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYKNRou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYKNRou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYKNRo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:44:26 -0500
Received: from kroah.org ([198.145.64.141]:44772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752104AbYKNRoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:44:25 -0500
Date: Fri, 14 Nov 2008 09:34:42 -0800
From: Greg KH <greg@kroah.com>
To: CaT <cat@zip.com.au>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.27.6
Message-ID: <20081114173442.GD22980@kroah.com>
References: <20081113185350.GA3765@kroah.com> <20081114051447.GC3413@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114051447.GC3413@zip.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 04:14:47PM +1100, CaT wrote:
> On Thu, Nov 13, 2008 at 10:53:50AM -0800, Greg KH wrote:
> > Francois Romieu (3):
> >       r8169: get ethtool settings through the generic mii helper
> 
> This appears to make the gigeth driver dependant on the mii sutff in the
> 100mbit driver submenu. Should it and if so doesn't this mean that the
> mii option best be moved out of the 100mbit menu (as this would make
> things a bit more logical - I don't expect to use stuff out of the
> 100mbit menu if I've only got gigeth cards)?

I'll backport the 'select this config option' patch that is needed to
ensure the build doesn't break here for the next .27.y stable release.

thanks,

greg k-h
