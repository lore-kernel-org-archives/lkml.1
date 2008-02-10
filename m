Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYBJVpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYBJVpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYBJVpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:45:35 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:44046 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYBJVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:45:34 -0500
Message-ID: <47AF707C.6050305@web.de>
Date: Sun, 10 Feb 2008 22:45:32 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [patch] kgdb light, v6
References: <20080210071331.GC3851@elte.hu> <20080210093128.GA11350@infradead.org> <20080210171742.GF7088@elte.hu> <200802102155.46505.bzolnier@gmail.com> <20080210210900.GA27162@elte.hu>
In-Reply-To: <20080210210900.GA27162@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/1kJ7n1UZOWl18Qhny/PeRDZDjompHfuBBk/JC
	Csg+S7NyG3y0gBoNyS3KipPejjSN7ocGzfil75YIUG5SFCrufs
	oJtEFkM9s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>>> +static int init_kgdboc(void)
>> __init
> 
> done.

Uuh, careful. We need this for runtime reconfiguration.

Jan
