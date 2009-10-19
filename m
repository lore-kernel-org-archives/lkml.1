Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZJSCpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZJSCpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 22:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZJSCpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 22:45:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:40831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbZJSCpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 22:45:22 -0400
Date: Mon, 19 Oct 2009 11:43:39 +0900
From: Arjan van de Ven <arjan@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfs mount fail
Message-ID: <20091019114339.4b67d947@infradead.org>
In-Reply-To: <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com>
	<84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 05:35:20 +0300
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> >
> > [  278.734149] ------------[ cut here ]------------
> > [  278.739620] kernel BUG at mm/slub.c:2969!
> 
> So this means that someone is passing a pointer to kfree() that did
> not come from kmalloc(). Which tree are you testing?

> > [  278.770030] Pid: 2594, comm: rpciod/0 Not tainted
> > 2.6.32-rc5-tip-01483-ga166936-dirty #651

some evil person decided to put the exact kernel tree/version in the
oops output ;-)


--
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
