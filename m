Return-Path: <linux-kernel-owner+w=401wt.eu-S1423015AbXBAVHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423015AbXBAVHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423016AbXBAVHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:07:09 -0500
Received: from dvhart.com ([64.146.134.43]:39341 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423015AbXBAVHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:07:07 -0500
Message-ID: <45C25628.9060100@mbligh.org>
Date: Thu, 01 Feb 2007 13:05:44 -0800
From: mbligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5 (Macintosh/20051201)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.753349000@jet.suse.cz> <200702011214.24126.ak@suse.de>
In-Reply-To: <200702011214.24126.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
>> TSC is either synchronized by design or not reliable
>> to be used for anything, let alone timekeeping.
> 
> In my tree this is already done better by a patch from Ingo.
> Check if they look synchronized and don't use TSC if they are not.

Is it going to notice dynamically when one cpu ramps down/up
during runtime, and looses sync?

M.

