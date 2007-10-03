Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbXJCASf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbXJCASf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXJCAS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:18:27 -0400
Received: from main.gmane.org ([80.91.229.2]:35761 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbXJCAS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:18:27 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Kernel 2.4 vs 2.6 Traffic Controller performance
Date: Tue, 2 Oct 2007 17:17:57 -0700
Organization: Linux Foundation
Message-ID: <20071002171757.2e5dbd0b@freepuppy.rosehill>
References: <9dbec86d0710021705j3a20e411hb3e9b34e622f9a85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <9dbec86d0710021705j3a20e411hb3e9b34e622f9a85@mail.gmail.com>
X-Newsreader: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 08:05:30 +0800
Sonny <smaniaol@gmail.com> wrote:

> Hello
> I hope this is the right place to ask this.Does any know if there is a
> substantial difference in the performance of the traffic controller
> between kernel 2.4 and 2.6. We tested it using 1 iperf server and use
> 250 and 500 clients, altering the burst. We use the top command to
> check the idle time of our router to see this. The results we got from
> the 2.4 kernel shows around 65-70% idle time while the 2.6 shows
> 60-65% idle time. We tried to use MRTG and we're not getting any
> results either. We want to know if we could improve the bandwidth by
> upgrading the kernel, else we would have to get a new bandwidth
> manager.  Could anyone have the similar test regarding this. Thanks in
> advance.

Some related thoughts:
1. Make sure you have the iperf yield fix in place. Otherwise iperf eats
   cpu.

2. Proper mailing lists are: netdev@vger.kernel.org and lartc@mailman.ds9a.nl

3. The latest versions of 2.6 use different clock measurement that
should be better than older 2.4 (where there are three choices).
The new clock is finer resolution (at slightly higher overhead), which
should make accuracy higher but might increase cpu usage.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

