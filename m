Return-Path: <linux-kernel-owner+w=401wt.eu-S1764739AbXKTXvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764739AbXKTXvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbXKTXvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:51:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679AbXKTXvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:51:05 -0500
Date: Tue, 20 Nov 2007 18:50:48 -0500
From: Dave Jones <davej@redhat.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: maximilian attems <max@stro.at>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANN] Squashfs 3.3 released
Message-ID: <20071120235048.GA15764@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Phillip Lougher <phillip@lougher.demon.co.uk>,
	maximilian attems <max@stro.at>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <472EFACA.1090308@lougher.demon.co.uk> <20071105115624.GJ14432@baikonur.stro.at> <4731E880.6010303@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4731E880.6010303@lougher.demon.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 04:32:00PM +0000, Phillip Lougher wrote:
 > maximilian attems wrote:
 > > On Mon, Nov 05, 2007 at 11:13:14AM +0000, Phillip Lougher wrote:
 > >
 > >> The next stage after this release is to fix the one remaining blocking issue
 > >> (filesystem endianness), and then try to get Squashfs mainlined into the
 > >> Linux kernel again.
 > >>
 > > 
 > > that would be very cool!
 > 
 > Yes, it would be cool :)  Five years is a long time to maintain
 > something out of tree, especially recently when there's been
 > so many minor changes to the VFS interface between kernel releases.
 > 
 > > with my hat as debian kernel maintainer i'd be very relieved to see it
 > > mainlined. i don't know of any major distro that doesn't ship it.
 > > 
 > 
 > I don't know of any major distro that doesn't ship Squashfs either
 > (except arguably Slackware).  Putting my other hat on (one of the
 > Ubuntu kernel maintainers) I don't think Squashfs has caused
 > distros that many problems because it is an easy patch to apply
 > (it doesn't touch that many kernel files), but it is always good
 > to minimise the differences from the stock kernel.org kernel.

The biggest problem we've seen with it (asides from having to rediff
it every time we rebase when there isn't a newer upstream) is complaints
along the lines of "my Fedora 7 kernel can't unpack squashfs images
from Fedora 5"
(s/Fedora 5/other random older distros/ )

If the format is now stable however, it would be great to get it upstream.

	Dave

-- 
http://www.codemonkey.org.uk
