Return-Path: <linux-kernel-owner+w=401wt.eu-S1765490AbXEWMPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765490AbXEWMPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760362AbXEWMPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:15:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36832 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454AbXEWMP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:15:29 -0400
Date: Wed, 23 May 2007 14:15:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       "Brown, Len" <len.brown@intel.com>, tglx@linutronix.de, mingo@elte.hu,
       "Zhu, Yi" <yi.zhu@intel.com>, linux-kernel@vger.kernel.org,
       arjan@infradead.org, trenn@suse.de
Subject: Re: Increased ipw2200 power usage with dynticks
Message-ID: <20070523121524.GA4999@one.firstfloor.org>
References: <20070522092359.GA13298@one.firstfloor.org> <653FFBB4508B9042B5D43DC9E18836F5EA5415@scsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5EA5415@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The current idea is that we will have multiple governors changeable at run time only for
> DEBUG and DEVELOPMENT. On a standard end user system there will be one governor
> (current optimal governor) that will be loaded. This gives
> flexibality to experiments with governors and also easily have different governors for
> different kind of platforms - in future if needed (handheld v/s laptop v/s server).
> Also, there are no overheads at runtime due to the fact that we have underlying infrastructure
> to have multiple governors (no locking overheads and such).

For testing/debugging you could just use some ifdefs, right? 

-Andi
