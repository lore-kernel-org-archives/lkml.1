Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbYISTMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbYISTMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYISTMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:12:39 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:54047 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYISTMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:12:39 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Jarod Wilson <jwilson@redhat.com>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Fri, 19 Sep 2008 21:12:38 +0200
User-Agent: KMail/1.9.5
Cc: Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809192026.21107.j@jannau.net> <200809191454.00617.jwilson@redhat.com>
In-Reply-To: <200809191454.00617.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809192112.38512.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: e3260060fbba42ba6f18958e4f5000eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2008 20:54, Jarod Wilson wrote:
> On Friday 19 September 2008 14:26:20 Janne Grunau wrote:
> > On Friday 19 September 2008 20:05:11 Stefan Bauer wrote:
> > > Thank you for keeping me up to date, here are my test results with
> > > todays (36e60bd457588b2a2fd37e0c1d0652a9fe214d85) git:
> > >
> > > - But lircd crashes immediately every time irexec/irw tries to
> > > connect:
> > >
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000c
> >
> > not necessary, it is
> > commit bc2039245c6390bd414a61c9395604c4155a58c6
> > Author: Janne Grunau <j@jannau.net>
> > Date:   Thu Sep 18 20:49:19 2008 +0200
> >
> >     reimplement lirc_buffer as kfifo wrapper
>
> Hm... Two things... First, I neglected to pull some of Janne's later
> changes in the same area until just a bit ago, so perhaps this has already
> been remedied, because second, lirc_i2c is working as expected w/current
> head (98242cbdca...)

98242cbdca behaves exactly as 36e60bd4575.

-Stefan
