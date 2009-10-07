Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbZJGVJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbZJGVJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZJGVJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:09:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46547 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbZJGVJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:09:14 -0400
Date: Wed, 7 Oct 2009 22:10:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael Guntsche <mike@it-loops.com>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-hotplug <linux-hotplug@vger.kernel.org>
Subject: Re: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
Message-ID: <20091007221001.7628c9aa@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510910071353v3bbe5bc7lc41e184fbc1ff7ed@mail.gmail.com>
References: <20091007175403.GA335@trillian.comsick.at>
	<9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com>
	<ac3eb2510910071306r4ad6dc9btb7503bc3ab0ec815@mail.gmail.com>
	<ac3eb2510910071312qe6ad45ep6c579a8393cc6b8e@mail.gmail.com>
	<20091007203121.GA432@trillian.comsick.at>
	<ac3eb2510910071353v3bbe5bc7lc41e184fbc1ff7ed@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 22:53:12 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Wed, Oct 7, 2009 at 22:31, Michael Guntsche <mike@it-loops.com> wrote:
> > add      /module/8250_pnp (module)
> > remove /devices/platform/serial8250/tty/ttyS0 (tty)
> > add      /devices/pnp0/00:05/tty/ttyS0 (tty)
> 
> That's pretty odd, that the loading of a module removes pre-existing
> devices created by other code, and creates new ones with the same name
> and major/minor.

Quite normal. The serial code has always done this.
