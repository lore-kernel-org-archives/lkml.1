Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbZBLPLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbZBLPLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 10:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbZBLPLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 10:11:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46602 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758106AbZBLPLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:11:34 -0500
Date: Thu, 12 Feb 2009 10:11:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Patrick McHardy <kaber@trash.net>
cc: netdev@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] SNAT sometimes allows packets to pass through unchanged
In-Reply-To: <4993B132.80908@trash.net>
Message-ID: <Pine.LNX.4.44L0.0902121008050.2388-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Patrick McHardy wrote:

> If the connection has already timed out (from conntracks perspective),
> it has lost its state. Unless connection pickup is enabled, the packet 
> will be marked as INVALID because it doesn't belong to a connection.
> You can control dropping of these packets yourself by adding the
> appropriate "-m state --state INVALID" rules.

I tried adding a rule to log these unaccounted-for packets.  Nothing 
showed up, even when I could see the packets being sent.

> That said, there were
> some bugs in the past few releases that caused some bad interaction
> between TCP and TCP conntrack (not sure anymore which one of both was
> to blame). Its possible that this is the root cause for this, so
> you might want to consider a kernel update.

It does sound like the result of a bug.  Do you have any pointers to 
patches or locations to check in the source?

Alan Stern

