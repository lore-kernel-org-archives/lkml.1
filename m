Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbXFRRVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbXFRRVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbXFRRUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:20:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbXFRRUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:20:51 -0400
Message-ID: <4676BEC2.7090809@redhat.com>
Date: Mon, 18 Jun 2007 11:20:02 -0600
From: Brendan Conoboy <blc@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: david@lang.hm
CC: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> in my case it takes 2+ days to resync the array before I can do any 
> performance testing with it. for some reason it's only doing the rebuild 
> at ~5M/sec (even though I've increased the min and max rebuild speeds 
> and a dd to the array seems to be ~44M/sec, even during the rebuild)

With performance like that, it sounds like you're saturating a bus 
somewhere along the line.  If you're using scsi, for instance, it's very 
easy for a long chain of drives to overwhelm a channel.  You might also 
want to consider some other RAID layouts like 1+0 or 5+0 depending upon 
your space vs. reliability needs.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
