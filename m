Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbYGOSlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbYGOSlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYGOSkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:40:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbYGOSkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:40:37 -0400
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
From: Dan Williams <dcbw@redhat.com>
To: Nicolas Pitre <nico@cam.org>
Cc: Michael Buesch <mb@bu3sch.de>,
       Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807151404530.12484@xanadu.home>
References: <20080709190915.GA8238@tuxdriver.com>
	 <69e28c910807100912h30fcb57fpb4fb48b95c640f77@mail.gmail.com>
	 <200807101815.27204.mb@bu3sch.de>
	 <1216142191.6039.113.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0807151323570.12484@xanadu.home>
	 <1216144711.13411.18.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0807151404530.12484@xanadu.home>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 14:38:38 -0400
Message-Id: <1216147118.13411.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 14:14 -0400, Nicolas Pitre wrote:
> On Tue, 15 Jul 2008, Dan Williams wrote:
> 
> > Some of the issues with the current Marvell 83xx GPL drivers that have
> > gotten out are (a) code style, (b) lots of commented out stuff that's
> > never used, (c) OS abstraction that's unnecessary on Linux, (d) doesn't
> > use mac80211, and (e) uses private ioctls.  So hopefully you're writing
> > a new 83xx driver from scratch :)
> 
> Yes, this is all from scratch.  The objective for this work is to be 
> "mainlinable".
> 
> > We cleaned up a lot of stuff for the OLPC 8388 libertas driver, but
> > unfortunately we never were able to get the Marvell 8388 team onboard,
> > and so they just went off and kept working on their driver and didn't
> > really move the upstream libertas driver forward at all.
> 
> Libertas is a rather different beast.

Obviously; this was just an observation about the last time we got a
wireless driver from Marvell.  I expect it to work out rather
differently this time simply on the strength of your and Lennert's
track-record, but if it's really just you two guys and you don't have
buy-in from the actual hardware and software teams inside Marvell, it's
hard to see how this wouldn't just happen again.

Dan

