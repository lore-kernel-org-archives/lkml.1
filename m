Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYITAKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYITAKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYITAKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:10:38 -0400
Received: from scing.com ([217.160.110.58]:51849 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbYITAKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:10:37 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Sat, 20 Sep 2008 02:10:33 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809192026.21107.j@jannau.net> <200809192053.36760.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <200809192053.36760.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809200210.33597.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2008 20:53:36 Stefan Bauer wrote:
> On Friday 19 September 2008 20:26, Janne Grunau wrote:
> >
> > not necessary, it is
> > commit bc2039245c6390bd414a61c9395604c4155a58c6
> > Author: Janne Grunau <j@jannau.net>
> > Date:   Thu Sep 18 20:49:19 2008 +0200
> >
> >     reimplement lirc_buffer as kfifo wrapper
>
> Thank you for pointing me, but
> bc2039245c6390bd414a61c9395604c4155a58c6~1 (lirc_streamzap can use
> lirc_buffer_clear) also crashes lircd when irexec is started.

yes, a different bug. both fixed in 
git://git.jannau.net/linux-2.6-lirc.git

but lirc serial still doesn't work after 
bc2039245c6390bd414a61c9395604c4155a58c6. I'll look at it tomorrow.

I have also good news: irrecord + lirc_serial is working with bc203924^. 
Not sure if something changed or if it was PEBCAK.

Janne
