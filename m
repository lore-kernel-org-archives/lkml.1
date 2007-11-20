Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbXKTAeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbXKTAeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXKTAd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:33:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbXKTAd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:33:58 -0500
Message-ID: <47422AA3.7060507@redhat.com>
Date: Mon, 19 Nov 2007 19:30:27 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Greg KH <greg@kroah.com>, David <david@unsolicited.net>,
       Jeremy Fitzhardinge <jeremy@goop.org>, gregkh@suse.de,
       Javier Kohen <jkohen@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
References: <1195323695.5240.16.camel@null.tough.com.ar> <20071117191211.GA12757@kroah.com> <473F498D.9090703@unsolicited.net> <20071117203705.GA21045@kroah.com> <20071118005538.GD26865@elte.hu>
In-Reply-To: <20071118005538.GD26865@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2007 07:55 PM, Ingo Molnar wrote:
> * Greg KH <greg@kroah.com> wrote:
> 
>> Great, thanks for tracking this down.
>>
>> Ingo, this corrisponds to changeset 
>> a115d5caca1a2905ba7a32b408a6042b20179aaa in mainline.  Is that patch 
>> incorrect?  Should this patch in the -stable tree be reverted?
> 
> hm, there are no such problems in .24 and the cpu_clock() and other 
> fixes i did were not picked up. Find the missing fixes below. They 
> should work just fine in .23 as it has the cpu_clock() functionality 
> too.
> 
> [ NOTE: the most robust thing is to make the .23 version match the .24
>   version of kernel/softlockup.c, so i included two other harmless
>   changes in this diff as well. ]
> 
> 	Ingo
> 
> ----------->
> commit a5f2ce3c6024a5bb895647b6bd88ecae5001020a
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Oct 16 23:26:08 2007 -0700
> 
> commit 43581a10075492445f65234384210492ff333eba
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Oct 16 23:26:08 2007 -0700

Those are just cosmetic / cleanup changes.

Don't you need commit a3b13c23f186ecb57204580cc1f2dbe9c284953a ??
