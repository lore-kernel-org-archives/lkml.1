Return-Path: <linux-kernel-owner+w=401wt.eu-S1946168AbXEBA0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946168AbXEBA0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946167AbXEBA0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:26:15 -0400
Received: from gw.goop.org ([64.81.55.164]:58993 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946170AbXEBA0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:26:14 -0400
Message-ID: <4637DA9F.3030503@goop.org>
Date: Tue, 01 May 2007 17:26:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix dynticks for voyager
References: <1177951131.3674.37.camel@mulgrave.il.steeleye.com> <20070501222432.GP11166@waste.org>
In-Reply-To: <20070501222432.GP11166@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, Apr 30, 2007 at 11:38:51AM -0500, James Bottomley wrote:
>   
>> As usual voyager tripped over an explicit boot CPU is zero assumption in
>> the dynticks code.  This is the fix I have queued in the voyager tree.
>>     
>
> Can we flush out all these assumptions by adding a constant offset
> somewhere? Or reversing the ordering?
>   

My understanding is that the boot CPU is random depending on who wins
the "I get to boot" bunfight.

    J

