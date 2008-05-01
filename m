Return-Path: <linux-kernel-owner+w=401wt.eu-S1764603AbYEASnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764603AbYEASnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbYEASni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:43:38 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47190 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbYEASnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:43:37 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 14:43:37 EDT
X-Originating-Ip: 216.16.235.2
Date: Thu, 1 May 2008 14:35:51 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501183551.GA26149@foursquare.net>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430183149.78d97597.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301841290.5994@woody.linux-foundation.org> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-16.457, required 5,
	autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	PLING_PLING 0.34)
X-Net-Direct-Inc-MailScanner-From: <cdfrey@netdirect.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 08:26:27AM -0700, Linus Torvalds wrote:
> So let me repeat:
> 
>  (1) we have new code. We always *will* have new code, hopefully. A few
>      million lines pe year.

Pardon this comment from an inexperienced kernel hacker, but it seems to
me that one of the main problems is subsystems stomping on each other
during the merge window, and a general confusion as to who is responsible
for what bugs that appear.

Perhaps a shorter merge window, using a round-robin approach, based on
subsystem, would help alleviate these issues?

This would:

	- give people a "known" tree to base their subsystem patches on,
		when their turn comes around

	- give a rough schedule if the round-robin was always consistent
		in order, or made known in advance

	- a shorter window would keep people from waiting too long for
		their turn

	- give those responsible for the currently merged subsystem
		motivation and clarity to fix bugs that do appear during
		their merge window


Problems I see with this approach:

	- those at the end of the cycle get the shaft, if previous changes
		affect their work

	- political issues with determining the order of the round-robin
		schedule


If I'm overlooking something, I'm sure someone will correct me. :-)

- Chris

