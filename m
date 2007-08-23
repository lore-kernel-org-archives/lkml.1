Return-Path: <linux-kernel-owner+w=401wt.eu-S1759164AbXHWHrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbXHWHrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 03:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbXHWHrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 03:47:07 -0400
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:47350 "EHLO
	honk1.physik.uni-konstanz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455AbXHWHrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 03:47:06 -0400
X-Greylist: delayed 2007 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 03:47:06 EDT
Date: Thu, 23 Aug 2007 09:13:32 +0200
From: Guido Guenther <agx@sigxcpu.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Mike Mohr <akihana@gmail.com>, Rene Herman <rene.herman@home.nl>,
       linux-kernel@vger.kernel.org, Bodo Eggert <7eggert@gmx.de>
Subject: Re: group ownership of tun devices -- nonfunctional?
Message-ID: <20070823071332.GA4559@bogon.ms20.nix>
References: <8Tpwf-3Nb-1@gated-at.bofh.it> <E1IMnHK-00012c-VC@be1.lrz> <46C86B6C.8090209@home.nl> <Pine.LNX.4.58.0708192333170.2426@be1.lrz> <20070822204254.GA13410@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822204254.GA13410@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wed, Aug 22, 2007 at 04:42:54PM -0400, Jeff Dike wrote:
> > I can create devices that are owned by my user account (tunctl -u
> > `whoami` -t tap0) and it works fine.  However, if I use group
> > permissions with -g it stops working.  In all cases, if I pass -g
> > <group>, the interface is created correctly but it is unusable as a
> > non-root user.
> 
> I can't reproduce this - it seems to work fine on -rc3-mm1:
Works fine here too. I had a similar report and there seems to be some
confusion since the group has to be the processes effective group not
any supplementary group the user happens to be in. Could that be the
problem here too?
Cheers,
 -- Guido
