Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbXEYVxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbXEYVxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbXEYVxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:53:13 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbXEYVxN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:53:13 -0400
Date: Fri, 25 May 2007 14:52:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IkouQS4gTWFnYWxs824i?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: idle=poll burns my box [was Re: 2.6.22-rc2-mm1]
Message-Id: <20070525145254.febcc9eb.akpm@linux-foundation.org>
In-Reply-To: <20070525232025.416b32d7@werewolf-wl>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<20070525232025.416b32d7@werewolf-wl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 23:20:25 +0200 "J.A. Magallón" <jamagallon@ono.com> wrote:

> Is idle=poll a quick and dirty way to burn your box in flames ?

yep ;)  It makes the CPU(s) busy-wait when they have nothing else to do.

It was originally added as a thing to maybe save a few cycles of latency
in responding to interrupts.  It's now useful as a trick to prevent oprofile
from producing confusing numbers.  I don't think it has any other uses.
