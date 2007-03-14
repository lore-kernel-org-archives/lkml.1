Return-Path: <linux-kernel-owner+w=401wt.eu-S1161309AbXCNOmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309AbXCNOmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161314AbXCNOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:42:53 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:33424 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161311AbXCNOmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:42:52 -0400
Date: Wed, 14 Mar 2007 10:42:51 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070314144251.GN22464@csclub.uwaterloo.ca>
References: <20070216185230.GO8882@enneenne.com> <20070313213842.GA23178@enneenne.com> <20070313224817.GF22466@csclub.uwaterloo.ca> <20070314093146.GE24556@enneenne.com> <20070314131934.GL22464@csclub.uwaterloo.ca> <20070314140623.GF3802@enneenne.com> <20070314141253.GM22464@csclub.uwaterloo.ca> <20070314142710.GJ3802@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314142710.GJ3802@enneenne.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 03:27:12PM +0100, Rodolfo Giometti wrote:
> Ok! Thanks.
> 
> Yes, this could be a good solution while waiting for a new setserial.

Now you said to check the return value of time_pps_readlink.  Well it
returns void so that isn't much good, and the stuff the wiki says to do,
appears to be done internally by the function.  So I guess that means I
should undo that change so that I can actually get ntpd to compile
again.

If the call was to readlink directly it needs to be done, while your
time_pps_readlink is just a handy wrapper that does all that for you,
right?

--
Len Sorensen
