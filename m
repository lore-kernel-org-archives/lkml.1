Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXCYOfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXCYOfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXCYOfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:35:25 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42932 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXCYOfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:35:24 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
X-Message-Flag: Warning: May contain useful information
References: <adad52xnccs.fsf@cisco.com> <20070325073146.GB10734@elte.hu>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 25 Mar 2007 07:35:22 -0700
In-Reply-To: <20070325073146.GB10734@elte.hu> (Ingo Molnar's message of "Sun, 25 Mar 2007 09:31:46 +0200")
Message-ID: <ada4po9mlw5.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2007 14:35:22.0946 (UTC) FILETIME=[D216CA20:01C76EEA]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I'm trying to use 2.6.21-rc4-rt1 to track down who's keeping 
 > > interrupts off for too long. [...]

 > btw., is this something you know for sure (if yes, how do you know?) - 
 > or is it that you would like to double-check the irqs-off times of 
 > v2.6.21-to-be?

I finally got curious enough to want to debug why starting kvm with
tun/tap networking produces a bunch of

    rtc: lost some interrupts at 1024Hz.

messages.  So I'm assuming it's a ~millisecond irqs-off section
somewhere.

 - R.
