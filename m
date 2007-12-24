Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXLXP6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXLXP6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXLXP6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:58:37 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43121 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbXLXP6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:58:36 -0500
Date: Mon, 24 Dec 2007 16:58:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/38] arch/x86/ia32: Use time_before, time_before_eq,
 etc.
In-Reply-To: <20071224153152.GA21971@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0712241657080.23999@ask.diku.dk>
References: <Pine.LNX.4.64.0712241522410.23999@ask.diku.dk>
 <20071224153152.GA21971@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2007, Andi Kleen wrote:

> On Mon, Dec 24, 2007 at 03:23:19PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The functions time_before, time_before_eq, time_after, and time_after_eq
> > are more robust for comparing jiffies against other values.
> 
> The old code was actually correct I think, but the change is ok for me.

Please ignore the patch.  All of my before_eq and after_eq's are 
backwards due to parsing <= as >= and vice versa.  I will try again.

julia

