Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYBIQrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYBIQrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbYBIQqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:46:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbYBIQqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:46:44 -0500
Date: Sat, 9 Feb 2008 11:43:29 -0500
From: Rik van Riel <riel@redhat.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: "Jon Masters" <jonathan@jonmasters.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Zan Lynx" <zlynx@acm.org>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Message-ID: <20080209114329.68820224@bree.surriel.com>
In-Reply-To: <2f11576a0802090833h7a600ee8x87edb423cbbb5d79@mail.gmail.com>
References: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com>
	<B846E82A-D513-40CD-A19C-B60653569269@jonmasters.org>
	<2f11576a0802090833h7a600ee8x87edb423cbbb5d79@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 01:33:49 +0900
"KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Where is the netlink interface? Polling an FD is so last century :)
> 
> to be honest, I don't know anyone use netlink and why hope receive
> low memory notify by netlink.
> 
> poll() is old way, but it works good enough.

More importantly, all gtk+ programs, as well as most databases and other
system daemons have a poll() loop as their main loop.

A file descriptor fits that main loop perfectly.

-- 
All rights reversed.
