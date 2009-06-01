Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZFARRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZFARRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZFARRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:17:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48844 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZFARRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:17:15 -0400
Date: Mon, 1 Jun 2009 19:11:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601171119.GA13970@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk> <20090601161234.GA10486@redhat.com> <20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Alan Cox wrote:
>
> > I think. As for other unhandled sig_fatal() signals, I am nor sure.
> > I can make a patch, but first I need to know what this patch should do.
> > Again, please look at:
>
> If you are on the command line then SIGINT/SIGQUIT would be the obvious
> ones for this ?

Not sure I understand. Do you mean we should treat the tty signals
specially ?

Personally, I don't think we should. If we decide that only SIGKILL
interrupts the coredumping, then I think ^C should not interrupt.

Oleg.

