Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXIZKp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXIZKp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 06:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXIZKpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 06:45:06 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1382 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbXIZKpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 06:45:04 -0400
Date: Wed, 26 Sep 2007 12:45:00 +0200
From: Olivier Galibert <galibert@pobox.com>
To: David Newall <david@davidnewall.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070926104500.GA4354@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	David Newall <david@davidnewall.com>,
	Kyle Moffett <mrmacman_g4@mac.com>, Adrian Bunk <bunk@kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
	majkls <majkls@prepere.com>, bunk@fs.tum.de,
	linux-kernel@vger.kernel.org
References: <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA341A.80706@davidnewall.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 07:57:38PM +0930, David Newall wrote:
> As has been said, there are thousands of ways to break out of a chroot.  
> It's just that one of them should not be that chroot lets you walk out.  

chroot does not allow you to walk out if you're in.  It only allows
you to walk outside if you're *already* out.  That's the way it is
defined.  Those who want some kind of chroot for security reasons
should look at (BSD's ?) jail, and/or hypervisors.

  OG.
