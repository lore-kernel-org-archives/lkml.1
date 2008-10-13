Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbYJMWvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbYJMWvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbYJMWuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:50:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50691 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031AbYJMWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:50:52 -0400
Date: Mon, 13 Oct 2008 23:50:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-git-a447c093244] BUG: spinlock bad magic on CPU#0,
 setserial/3527
Message-ID: <20081013235013.17e3106b@lxorguk.ukuu.org.uk>
In-Reply-To: <200810140005.39852.rjw@sisk.pl>
References: <200810140005.39852.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 00:05:39 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
> 
> The Linus' tree from today on Asus L5D:
> 
> BUG: spinlock bad magic on CPU#0, setserial/3527
>  lock: ffffffff80dae020, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> Pid: 3527, comm: setserial Not tainted 2.6.27-git #57

Yep looking at that at the moment. Its a fallout from dropping the NR_IRQ
removal changes from the serial tree just before merging I think. Was
done to make life simpler for Ingo's code push but appears to have
slightly backfired.

Alan
