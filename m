Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYJTHoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYJTHoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYJTHn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:43:58 -0400
Received: from gw.goop.org ([64.81.55.164]:52882 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbYJTHn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:43:57 -0400
Message-ID: <48FC36B9.6000704@goop.org>
Date: Mon, 20 Oct 2008 00:43:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, maluta_tiago@yahoo.com.br,
       lguest@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [Lguest] lguest: unhandled trap
References: <713731.28571.qm@web50701.mail.re2.yahoo.com> <200810201452.04932.rusty@rustcorp.com.au> <20081020072236.GD12131@elte.hu>
In-Reply-To: <20081020072236.GD12131@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i think Xen can withstand DMI scanning just fine.
>
> without having seen any background, my general feeling is that lguest 
> should either do what Xen does and reserve the classic BIOS ranges that 
> we probe - or we should make DMI scanning more robust by making sure 
> real RAM ranges are never probed. (only ranges that the BIOS itself 
> marks as reserved in the e820 map) 

We considered doing that, but decided that there was so many other 
pieces of code around the place that assume that the ISA area is 
special, that just reserving it was the best course of action.

    J
