Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYBKCgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYBKCgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 21:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYBKCfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 21:35:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:30058 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYBKCfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 21:35:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GZiHFwILIzs75xDFQZs4UBOBYHEVyjLLPO0n8P2g0B8CgOK0G/P5tSPVfnY5ShsKbU41hnG07d7cZbkgCpUxux2WYYv7QyLZGh9z9OTxNvWN/9YY+sFGv/2lJRszYDaJ9shjVFiPPI9swaVgjg2RSYZ3FiRZ/kjGeVEucAYjmjI=
Message-ID: <86802c440802101835j58216bf5v50583bd69d6780b2@mail.gmail.com>
Date: Sun, 10 Feb 2008 18:35:53 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] kgdb light, v6
Cc: "Jan Kiszka" <jan.kiszka@web.de>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jason Wessel" <jason.wessel@windriver.com>
In-Reply-To: <20080210224047.GA21420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080210071331.GC3851@elte.hu> <20080210210900.GA27162@elte.hu>
	 <47AF707C.6050305@web.de> <200802102314.19500.bzolnier@gmail.com>
	 <47AF7B6D.1000901@web.de> <20080210224047.GA21420@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 2:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jan Kiszka <jan.kiszka@web.de> wrote:
>
> > Ingo, please keep the original annotations, they where correct and
> > should have been optimal (under the given constraints or runtime
> > reconfiguration).
>
> agreed. I've regenerated the -v7 tree with this trivial revert. Tip is
> commit 04b94b1dd5197bf737073ebbd4189ffdfdcea534, updated shortlog,
> diffstat and patch can be found below. Tree is at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git
>

something related or not.

my server doesn't have serial connector. the SP has serial port to
host's internal serial port.
I need to ssh to SP ( service processor) and start console there.

wonder if there is program that is running on SP, and one program on
develop workstation --- make it have one virtual serial port

gdb or other legacy serial port program could use that virtual serial port.

YH
