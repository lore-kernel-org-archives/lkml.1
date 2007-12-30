Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXL3Uyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXL3Uyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXL3UyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:54:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbXL3UyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:54:24 -0500
Message-ID: <4778052E.8000808@zytor.com>
Date: Sun, 30 Dec 2007 12:53:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it> <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it> <E1J92JB-00013N-P3@be1.7eggert.dyndns.org>
In-Reply-To: <E1J92JB-00013N-P3@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> 
> I've never seen code which would do that, and it was not suggested by any
> tutorial I ever saw. I'd expect any machine to break on all kinds of software
> if it required this. The only thing I remember being warned about is writing
> the index and the data register at the same time using outw, because that
> would write both registers at the same time on 16-bit-cards.
> 

And we use that, and have been for 15 years.  I haven't seen any screams 
of pain about it.

	-hpa
