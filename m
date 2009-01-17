Return-Path: <linux-kernel-owner+w=401wt.eu-S1765523AbZAQQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765523AbZAQQvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbZAQQvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:51:04 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47114 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbZAQQvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:51:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=osqFrVbttkmN/swynvfdcqoqRkvuXobSTK25K2HLD/FqwhepIzT0Njrqx/Go1QRNpE
         pEjwl0LxdXmLfSeWd+YgUQwzEB2qVURokaHgy1NWXP2pr+6/VGXrvIbKyHinRGAPGyr+
         SAP/DvbzFNGWQlKa889bUuBpd+o/zGE1AL8MM=
Message-ID: <c384c5ea0901170850q4c72d8bcpc76eb635950aaa2e@mail.gmail.com>
Date: Sat, 17 Jan 2009 17:50:59 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Cc: "Jens Axboe" <axboe@kernel.dk>, "Andrea Arcangeli" <andrea@suse.de>,
       akpm@linux-foundation.org, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20090117162657.GA31965@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mathieu et al,

On Sat, Jan 17, 2009 at 5:26 PM, Mathieu Desnoyers
<mathieu.desnoyers@polymtl.ca> wrote:
> A long standing I/O regression (since 2.6.18, still there today) has hit
> Slashdot recently :
> http://bugzilla.kernel.org/show_bug.cgi?id=12309

Are you sure you are solving the *actual* problem?

The bugzilla entry shows a bisect attempt that leads to a patch
involving negative clock jumps.
http://bugzilla.kernel.org/show_bug.cgi?id=12309#c29

with a corrected link to the bisect patch:
http://bugzilla.kernel.org/show_bug.cgi?id=12309#c30

Wouldn't a negative clock jump be very influential to the
(time-driven) I/O schedulers and be a more probable cause?

Regards,
-- 
Leon

p.s. Added Thomas to the CC list as his name is on the patch Signed-off-by list.
