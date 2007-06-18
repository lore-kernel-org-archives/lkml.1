Return-Path: <linux-kernel-owner+w=401wt.eu-S1764931AbXFRSIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764931AbXFRSIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760828AbXFRSIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:08:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762157AbXFRSIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:08:12 -0400
Message-ID: <4676C9FF.7060607@redhat.com>
Date: Mon, 18 Jun 2007 12:07:59 -0600
From: Brendan Conoboy <blc@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: david@lang.hm
CC: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> I plan to test the different configurations.
> 
> however, if I was saturating the bus with the reconstruct how can I fire 
> off a dd if=/dev/zero of=/mnt/test and get ~45M/sec whild only slowing 
> the reconstruct to ~4M/sec?
> 
> I'm putting 10x as much data through the bus at that point, it would 
> seem to proove that it's not the bus that's saturated.

I am unconvinced.  If you take ~1MB/s for each active drive, add in SCSI 
overhead, 45M/sec seems reasonable.  Have you look at a running iostat 
while all this is going on?  Try it out- add up the kb/s from each drive 
and see how close you are to your maximum theoretical IO.

Also, how's your CPU utilization?

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
