Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYGDUlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYGDUlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYGDUlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:41:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51955 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752232AbYGDUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:41:13 -0400
Date: Fri, 4 Jul 2008 21:23:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Peterson <joe@skyrush.com>
Cc: Elias Oltmanns <eo@nebensachen.de>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
Message-ID: <20080704212335.4ffc8230@lxorguk.ukuu.org.uk>
In-Reply-To: <486E83C3.1040509@skyrush.com>
References: <48661488.10304@gmail.com>
	<87fxqurqpz.fsf@denkblock.local>
	<486E83C3.1040509@skyrush.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> disk activity process over each time it completed), it always broke out
> after one ^C - one time took an extra second or two.  Note that I did
> not run latencytop (did not have it compiled in my kernel) - if that is
> required for the test, let me know, but I assume it is just for
> gathering info when the issue occurs.

I really don't think this is tty related looking at the code involved and
also the lack of actual measurements presented. More likely scheduler and
VM related changes.

Alan
