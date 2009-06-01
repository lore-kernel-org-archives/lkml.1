Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZFAVfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZFAVfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZFAVfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:35:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57298 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751772AbZFAVfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:35:33 -0400
Date: Mon, 1 Jun 2009 22:34:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: paul@mad-scientist.net
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601223455.00609acc@lxorguk.ukuu.org.uk>
In-Reply-To: <1243885899.8547.95.camel@psmith-ubeta.netezza.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<1243877766.8547.38.camel@psmith-ubeta.netezza.com>
	<20090601184934.1fc54411@lxorguk.ukuu.org.uk>
	<1243881544.8547.66.camel@psmith-ubeta.netezza.com>
	<20090601200232.078aacbb@lxorguk.ukuu.org.uk>
	<1243885899.8547.95.camel@psmith-ubeta.netezza.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it's interactive, can't the user ^Z (SIGSTOP)

^Z is SIGTSTP but that would be one way to implement it although I think
it might need a bit more work than just setting masks.

> Yes, you need a shell with job control but... at some point we have to
> just say it is what it is!  Core dumps are not just annoying time/disk
> space wasters, they have real value; a good core dump can save tens of
> thousands of dollars or more in support and development costs.  We need
> (a way for) them to be reliable, even if it costs some interactive
> ease-of-use.
> 
> Anyway, that's my opinion :-)

And there we get into policy and preference rather than technical debate
- no right answers 8(
