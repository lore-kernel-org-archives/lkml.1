Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbYBKWP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbYBKWP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYBKWPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:15:19 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:10411 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYBKWPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:15:18 -0500
Date: Mon, 11 Feb 2008 23:15:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] Only do century BCD conversion when we know the RTC is BCD
Message-ID: <20080211221514.GA12592@basil.nowhere.org>
References: <20080209416.271135970@suse.de> <alpine.LFD.1.00.0802110924050.12988@apollo.tec.linutronix.de> <200802110956.16004.ak@suse.de> <alpine.LFD.1.00.0802112246590.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802112246590.12988@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Feb 2008 22:08:53.0815 (UTC) FILETIME=[B0752470:01C86CFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the warning comes a bit late :)

I suspect if this was wrong before it would not have been noticed
because user space hwclock would work around it. The warning
certainly won't hurt.

Anyways if you feel strongly about this (I don't) then drop
this patch, but apply the other ones in the series. The main
one I consider important is the change to the 2000 offset for 32bit
to extend the 32bit lifetime.

-Andi
