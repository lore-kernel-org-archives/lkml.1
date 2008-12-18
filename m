Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752806AbYLRTDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYLRTDl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYLRTD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:03:28 -0500
Received: from kroah.org ([198.145.64.141]:60552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbYLRTD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:03:27 -0500
Date: Thu, 18 Dec 2008 11:00:15 -0800
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?Fran=E7ois?= Valenduc 
	<francois.valenduc@tvcablenet.be>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/83] 2.6.27.9-stable review
Message-ID: <20081218190015.GA7128@kroah.com>
References: <20081211191014.GA5759@suse.de> <49438093.9030809@tvcablenet.be> <20081216232530.GA11262@suse.de> <49494BDB.1000100@tvcablenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49494BDB.1000100@tvcablenet.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 07:58:35PM +0100, François Valenduc wrote:
> Greg KH a écrit :
> > On Sat, Dec 13, 2008 at 10:29:55AM +0100, François Valenduc wrote:
> >   
> >> Greg KH a écrit :
> >>     
> >>> This is the start of the stable review cycle for the 2.6.27.9 release.
> >>> There are 83 patches in this series, all will be posted as a response to
> >>> this one.  If anyone has any issues with these being applied, please let
> >>> us know.  If anyone is a maintainer of the proper subsystem, and wants
> >>> to add a Signed-off-by: line to the patch, please respond with it.
> >>> These patches are sent out with a number of different people on the Cc:
> >>> line.  If you wish to be a reviewer, please email stable@kernel.org to
> >>> add your name to the list.  If you want to be off the reviewer list,
> >>> also email us.
> >>> Responses should be made by December 13, 2008, 20:00:00 UTC.
> >>> Anything received after that time might be too late.
> >>> The whole patch series can be found in one patch at:
> >>> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.9-rc1.gz
> >>> and the diffstat can be found below.
> >>> thanks,
> >>> greg k-h
> >>>       
> >> Would it be possible to add these two patches ?
> >>
> >> commit 8258becf07e71236aac8cf5406a1345712f9ac25
> >> Author: Johannes Berg <johannes@sipsolutions.net>
> >> Date:   Tue Sep 23 19:18:43 2008 +0200
> >>
> >>     iwlagn: downgrade BUG_ON in interrupt
> >>
> >> commit 199d9de726ff2f949405279665a9c8b38966239b
> >> Author: Johannes Berg <johannes@sipsolutions.net>
> >> Date:   Tue Nov 18 01:47:21 2008 +0100
> >>
> >>     iwlagn: fix RX skb alignment
> >>
> >> Without these ones, my computer freezes very frequently (see bugs 11393, 
> >> 11983 and 12173 which in fact is a duplicate of the previous one).
> >> These two patches can be applied without any rejects on kernel 2.6.27.8.
> >>     
> >
> > I don't see these patches in Linus's kernel tree.  Are they not there?
> >
> > Or if they are there, can you give me the correct git commit ids for
> > them?
> >
> > thanks,
> >
> > greg k-h
> >
> >   
> 
> These commit ids are indeed not the one of linus's tree and they
> correspond to my local tree for kernel 2.6.27. The correct ids should
> be  4018517a1a69a85c3d61b20fa02f187b80773137 and 

That one is already in the 2.6.27.9 release

> 55d6a3cd0cc85ed90c39cf32e16f622bd003117b.

I have queued this one up now.

thanks,

greg k-h
