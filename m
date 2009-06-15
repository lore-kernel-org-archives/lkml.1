Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbZFOPNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbZFOPNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbZFOPNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:13:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58921 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760068AbZFOPNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:13:33 -0400
Date: Mon, 15 Jun 2009 16:14:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Debug bits for the tty ldisc problem
Message-ID: <20090615161439.507fb04b@lxorguk.ukuu.org.uk>
In-Reply-To: <1245076796.6800.488.camel@laptop>
References: <20090615153015.4036.76588.stgit@t61.ukuu.org.uk>
	<1245076796.6800.488.camel@laptop>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 16:39:56 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-06-15 at 16:32 +0100, Alan Cox wrote:
> > I'm not 100% sure the close one is
> > safe for locking but as the lock detector has been busted since 2.6.30 its a
> > bit hard to be sure.
> 
> Would you have some specifics?

I stuck it in bugzilla basically it blows up with a 

BUG: MAX_STACK_TRACE_ENTRIES too low! turning off the locking correctness
validator.

and has done for ages.

