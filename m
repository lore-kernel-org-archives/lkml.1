Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYISS4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYISS4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYISS4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:56:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42304 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYISS4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:56:22 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Fri, 19 Sep 2008 14:54:00 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809192005.12068.stefan.bauer@cs.tu-chemnitz.de> <200809192026.21107.j@jannau.net>
In-Reply-To: <200809192026.21107.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809191454.00617.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2008 14:26:20 Janne Grunau wrote:
> On Friday 19 September 2008 20:05:11 Stefan Bauer wrote:
> > Thank you for keeping me up to date, here are my test results with
> > todays (36e60bd457588b2a2fd37e0c1d0652a9fe214d85) git:
> >
> > - But lircd crashes immediately every time irexec/irw tries to
> > connect:
> >
> > BUG: unable to handle kernel NULL pointer dereference at 0000000c
>
> not necessary, it is
> commit bc2039245c6390bd414a61c9395604c4155a58c6
> Author: Janne Grunau <j@jannau.net>
> Date:   Thu Sep 18 20:49:19 2008 +0200
>
>     reimplement lirc_buffer as kfifo wrapper

Hm... Two things... First, I neglected to pull some of Janne's later changes 
in the same area until just a bit ago, so perhaps this has already been 
remedied, because second, lirc_i2c is working as expected w/current head 
(98242cbdca...)


-- 
Jarod Wilson
jarod@redhat.com

