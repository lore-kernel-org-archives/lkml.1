Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYHAPcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYHAPcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYHAPcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:32:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYHAPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:32:00 -0400
Message-ID: <48932B1B.70303@zytor.com>
Date: Fri, 01 Aug 2008 08:26:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Peter Oruba <peter.oruba@amd.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Max Krasnyansky <maxk@qualcomm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
References: <20080729154103.007575982@amd.com>	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com> <b647ffbd0808010425r16db2957i3e7212903a698c19@mail.gmail.com>
In-Reply-To: <b647ffbd0808010425r16db2957i3e7212903a698c19@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> Tigran, Peter,
> 
> may a firmware package contain a few 'microcode' updates for a specific cpu?
> 
> And if so, does each of them provide independent 'errata' fixes? [*]
> 
> (or they are just different versions of the same self-consistent/full
> 'microcode' update and we may need to apply each of them just e.g.
> because we can't jump from stepping X.1 to X.3 without applying X.2 in
> between?
> 
> if it's [1], then I wonder why only a single 'microcode' update (which
> has been previously cached in 'uci->mc') is being applied for the case
> of system-wide resume (apply_microcode_check_cpu()). Don't we need to
> go through the full cpu_request_microcode() cycle to consider all
> updates?
> 

No, there is only ever one microcode; you only run the latest one.

	-hpa
