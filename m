Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYFQNhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYFQNhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 09:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbYFQNhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 09:37:09 -0400
Received: from [194.117.236.238] ([194.117.236.238]:53323 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYFQNhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 09:37:07 -0400
Date: Tue, 17 Jun 2008 16:35:51 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tom Zanussi <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
Message-ID: <20080617163551.49f96c7d@linux360.ro>
In-Reply-To: <20080617131036.GB8696@Krystal>
References: <20080613040958.4f52ee29@linux360.ro>
	<1213417601.8237.37.camel@charm-linux>
	<20080614181103.17617db1@linux360.ro>
	<20080616122249.GB18561@Krystal>
	<20080616162212.27a8c119@linux360.ro>
	<20080616164609.GM20851@kernel.dk>
	<84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
	<20080616182843.GS20851@kernel.dk>
	<20080617153934.59a7c7ee@linux360.ro>
	<20080617154923.36195161@linux360.ro>
	<20080617131036.GB8696@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 09:10:36 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> Do you get the same results when not using a buffered read to read
> /proc/PID/stat ? Also, since the internal proc handle might buffer the
> information, closing the file and re-opening it after the set affinity
> would not be a bad idea.
> 
> Mathieu

Tested your suggestions now, looks fine. 5 instances end up on CPU 1,
one on CPU 0, no errors printed by the application.


	Eduard
