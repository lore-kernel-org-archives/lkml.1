Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYANTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYANTzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYANTza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:55:30 -0500
Received: from gw.goop.org ([64.81.55.164]:51004 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbYANTz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:55:28 -0500
Message-ID: <478BBE13.9010308@goop.org>
Date: Mon, 14 Jan 2008 11:54:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault III
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478B9183.3020101@goop.org> <20080114165635.GK15542@elte.hu> <20080114170856.GA18412@one.firstfloor.org> <20080114171838.GA18662@one.firstfloor.org> <20080114190004.GB26540@elte.hu>
In-Reply-To: <20080114190004.GB26540@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm. Did the hanging kernel have the i387 regset fix from Roland already? 
> That bug indeed manifested itself as rare desktop hangs.
>
> other than that i know of no pending instability but the large-RAM 
> bootup crash you reported.

I read that as Andi is having general stability problems rather than 
specific large memory ones.

I've been running x86 pretty stably on my 2G 32-PAE machine.  I had 
problems a few days ago with X crashing on startup, but I attributed 
that to the 387 problem (it went away after an x86.git update).

    J
