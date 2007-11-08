Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbXKHXEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbXKHXEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXKHXEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:04:31 -0500
Received: from gw.goop.org ([64.81.55.164]:58633 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbXKHXEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:04:30 -0500
Message-ID: <473395BF.6030808@goop.org>
Date: Thu, 08 Nov 2007 15:03:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Zach Amsden <zach@vmware.com>
Subject: Re: [PATCH RFC 3/7] x86: clean up asm-x86/page*.h
References: <20071108015008.660012621@goop.org>	 <20071108015310.218076184@goop.org>	 <5d6222a80711080842i201cb431le966d5069d59db24@mail.gmail.com>	 <473378B3.1090700@goop.org> <5d6222a80711081438n228bbb93w3212ec7fdda361c@mail.gmail.com>
In-Reply-To: <5d6222a80711081438n228bbb93w3212ec7fdda361c@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Not exactly.
> for the native_ functions,  there's room for code sharing.
> native_pgd_val, and native_pte_val seem to be the same, for at least
> pae and x86_64.
> As for the typedefs, the same thing can be done. Much like you did in
> paravirt.h, just split out between the < 3 and >= 3 levels.

Yeah, I see what you mean.  I'll play with it and see how it turns out.

    J
