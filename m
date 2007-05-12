Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbXELTNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbXELTNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759210AbXELTMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:12:54 -0400
Received: from ns2.mvista.com ([63.81.120.158]:38922 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbXELTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:12:54 -0400
Subject: Re: [PATCH 1/2] non-string based tsc unstable reasons
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, mingo@elte.hu
In-Reply-To: <200705122056.42926.ak@suse.de>
References: <20070512154344.395866578@mvista.com>
	 <200705122056.42926.ak@suse.de>
Content-Type: text/plain
Date: Sat, 12 May 2007 12:10:48 -0700
Message-Id: <1178997048.27889.13.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 20:56 +0200, Andi Kleen wrote:
> On Saturday 12 May 2007 17:43:45 Daniel Walker wrote:
> > Just passing a string to mark_tsc_unstable() doesn't allow real code to change
> > based on the reason for the instablility. I changed mark_tsc_unstable()
> > to accept a string and a flag which denotes a general reason why the tsc
> > is unstable, and can be evaluated in code.
> > 
> > This is based off John Stultz patch to add the string reasons.
> 
> This seems ugly -- it would be better to just do whatever needs to
> be doing in the caller instead of passing down a enum and then switch.
> 
> And why do you really need it anyways?

Sending the string in mark_tsc_unstable() is already in linus-git
AFAIK .. The enum is just to allow sched_clock to switch off the TSC in
some situations, and not all.. 

Daniel

