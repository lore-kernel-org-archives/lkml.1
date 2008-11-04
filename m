Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYKDUGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYKDUGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYKDUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:06:28 -0500
Received: from gw.goop.org ([64.81.55.164]:39512 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbYKDUG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:06:27 -0500
Message-ID: <4910AB3F.3010205@goop.org>
Date: Tue, 04 Nov 2008 12:06:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <491090F3.5020701@zytor.com> <1225824256.28612.1282966677@webmail.messagingengine.com> <4910A390.409@zytor.com>
In-Reply-To: <4910A390.409@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> - we can no longer redirect a stub away from common code by
>   changing the branch in that slot.  We have to instead modify
>   the IDT.  This means "dedicated" interrupts don't get the
>   vector number at all, which is probably fine -- to be honest,
>   I'm not sure if they do at the moment either.
>   

They do, and the various patches to multiplex things like IPIs across 
multiple vectors rely on it.

    J
