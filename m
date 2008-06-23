Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYFWLei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYFWLei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYFWLe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:34:27 -0400
Received: from bar.sig21.net ([88.198.146.85]:38287 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbYFWLe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:34:27 -0400
Date: Mon, 23 Jun 2008 13:34:22 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com
Subject: Re: [patch] x86 supports NO_IRQ convention
Message-ID: <20080623113422.GA20419@linuxtv.org>
References: <200806221953.18849.david-b@pacbell.net> <20080623100823.61213c3f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623100823.61213c3f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-21-Score: -4.2 (----)
X-Spam-21-Report: No, score=-4.2 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.214,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 10:08:23AM +0100, Alan Cox wrote:
> 
> Zero is not a valid IRQ in the kernel mapping of things. If you have a
> physical IRQ 0 remap it.

I'm confused. On my Thinkpad with kernel 2.6.25 I get:

$ cat /proc/interrupts
           CPU0
  0:    4398925    XT-PIC-XT        timer
  1:     287065    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
...


Johannes
