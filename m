Return-Path: <linux-kernel-owner+w=401wt.eu-S940239AbXGaBuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940239AbXGaBuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbXGaBtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:49:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47023 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757531AbXGaBtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:49:50 -0400
Date: Mon, 30 Jul 2007 18:48:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Korty <joe.korty@ccur.com>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       jason.baietto@ccur.com
Subject: Re: [PATCH] expand /proc/interrupts to include missing vectors, v2
Message-Id: <20070730184836.63ad64d2.akpm@linux-foundation.org>
In-Reply-To: <20070731001718.GA14295@tsunami.ccur.com>
References: <20070726180522.GA1486@tsunami.ccur.com>
	<46A8EE78.4040702@zytor.com>
	<1185816797.3170.1.camel@sven.thebigcorporation.com>
	<20070730123206.abeab890.akpm@linux-foundation.org>
	<20070731001718.GA14295@tsunami.ccur.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 20:17:18 -0400 Joe Korty <joe.korty@ccur.com> wrote:

> +		seq_printf(p, "RES: ");
> +		seq_printf(p, "CAL: ");
> +		seq_printf(p, "TLB: ");
> +		seq_printf(p, "TRM: ");

Documentation/filesystems/proc.txt presently describes NMI:, LOC: and ERR:.
Are you thinking what I'm thinking?  ;)

