Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZBPKnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZBPKnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZBPKnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:43:32 -0500
Received: from stinky.trash.net ([213.144.137.162]:53135 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZBPKnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:43:31 -0500
Message-ID: <4999434F.1050101@trash.net>
Date: Mon, 16 Feb 2009 11:43:27 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: netdev@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] SNAT sometimes allows packets to pass through unchanged
References: <Pine.LNX.4.44L0.0902121008050.2388-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902121008050.2388-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 12 Feb 2009, Patrick McHardy wrote:
> 
>> If the connection has already timed out (from conntracks perspective),
>> it has lost its state. Unless connection pickup is enabled, the packet 
>> will be marked as INVALID because it doesn't belong to a connection.
>> You can control dropping of these packets yourself by adding the
>> appropriate "-m state --state INVALID" rules.
> 
> I tried adding a rule to log these unaccounted-for packets.  Nothing 
> showed up, even when I could see the packets being sent.

Where (table/chain/position) did you add this rule?

>> That said, there were
>> some bugs in the past few releases that caused some bad interaction
>> between TCP and TCP conntrack (not sure anymore which one of both was
>> to blame). Its possible that this is the root cause for this, so
>> you might want to consider a kernel update.
> 
> It does sound like the result of a bug.  Do you have any pointers to 
> patches or locations to check in the source?

Sorry, there were quite a few patches and I don't remember which
ones exactly are related.
