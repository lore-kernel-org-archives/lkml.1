Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYHMJhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYHMJhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbYHMJh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:37:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46671 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754838AbYHMJh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:37:26 -0400
Date: Wed, 13 Aug 2008 10:20:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Javeed Shaikh" <syscrash2k@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20080813102017.5f5a579b@lxorguk.ukuu.org.uk>
In-Reply-To: <12e8e7240808121658r3f7fb75cre6fb258959742ea3@mail.gmail.com>
References: <12e8e7240808111951o19afce35h48b693a618bd6120@mail.gmail.com>
	<12e8e7240808112103m21659d4fg3f30a139ae493473@mail.gmail.com>
	<12e8e7240808121658r3f7fb75cre6fb258959742ea3@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 19:58:20 -0400
"Javeed Shaikh" <syscrash2k@gmail.com> wrote:

> I appear to have fixed it.

You've moved the race.

> It seems that SIGWINCH was being fired off before the tty's size was
> updated, as Ico hypothesized.

There is what I believe to be a correct fix in the -next tree. It is a
bit invasive for 2.6.27 given we are in the -rc tree but I could push the
relevant pieces if the problem justifies the risk

Alan
