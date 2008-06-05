Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbYFERwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbYFERwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYFERwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:52:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbYFERwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:52:38 -0400
Date: Thu, 5 Jun 2008 13:45:35 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: via agp patches
Message-ID: <20080605174535.GA10361@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <20080531003214.GA6208@suse.de> <20080531003250.GB6208@suse.de> <20080531144715.GA22616@redhat.com> <20080531174113.GA18996@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531174113.GA18996@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 10:41:13AM -0700, Greg KH wrote:
 > On Sat, May 31, 2008 at 10:47:15AM -0400, Dave Jones wrote:
 > > On Fri, May 30, 2008 at 05:32:50PM -0700, Greg KH wrote:
 > >  > 
 > >  > Looks like this adds a new device id, I have no idea why they remove
 > >  > another one at the same time...
 > > 
 > > I sent a patch adding the missing ident to airlied a few weeks back.
 > > I think it's currently in -mm.
 > 
 > Great.
 > 
 > > The removal of the other id is a mystery to me.
 > 
 > Here's what I got back from Via about this:
 > 	VT3336 is a chipset for AMD Athlon/K8 CPU. Due to K8's unique
 > 	architecture, the AGP resource and behavior are different from
 > 	the traditional AGP which resides only in chipset. AGP is used
 > 	by 3D driver which wasn't available for the VT3336 and VT3364
 > 	generation until now.  Unfortunately, by testing, VT3364 works
 > 	but VT3336 doesn't. That is why the subtraction. I think other
 > 	options are leaving it in the AGP, but removing it from our DRI
 > 	driver. Or, just leave it in both but warn people for issues in
 > 	the release note.
 > 
 > 
 > So it sounds like it would be good to remove that id.

Sounds plausible. This needs to go in the changelog.
A lot of their K8 chipsets were also used on P4 (I think they
abstracted the architectural differences with V-Link), but
if they claim this wasn't used on any of the P4 boards,
I guess they would know better than us.

(The irony here is that the cset that introduced that ID came
 from a patch where someone copied a giant diff on one of VIA's
 earlier portals).

	Dave

-- 
http://www.codemonkey.org.uk
