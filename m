Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYGDKLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYGDKLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 06:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYGDKLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 06:11:06 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:15146 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYGDKLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 06:11:05 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, tytso@mit.edu, jeff@garzik.org,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: Andi Kleen <andi@firstfloor.org>
References: <1215093175.10393.567.camel@pmac.infradead.org>
	<20080703173040.GB30506@mit.edu>
	<1215111362.10393.651.camel@pmac.infradead.org>
	<20080703.162120.206258339.davem@davemloft.net>
	<486D6DDB.4010205@infradead.org>
Date: Fri, 04 Jul 2008 12:09:08 +0200
In-Reply-To: <486D6DDB.4010205@infradead.org> (David Woodhouse's message of "Fri, 04 Jul 2008 01:24:59 +0100")
Message-ID: <87ej6armez.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jul 2008 10:01:47.0096 (UTC) FILETIME=[F8641D80:01C8DDBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:
>
> I'll look at making the requirement for 'make firmware_install' more
> obvious, or even making it happen automatically as part of
> 'modules_install'.

Perhaps I didn't pay enough attention, but how are "only 
boot bzImage without initrd or modules" setups supposed to work now
for those drivers? My testing setup relies on that heavily.

Will the firmware automatically end up in initramfs and be included
in the bzImage and loaded at the right point?

I hope we won't let lawyers decide technical topics here.

-Andi
