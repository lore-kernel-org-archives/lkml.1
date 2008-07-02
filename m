Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYGBIGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYGBIGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYGBIFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:05:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44120 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751444AbYGBIFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:05:50 -0400
Date: Wed, 2 Jul 2008 08:48:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Donkey Ia" <d0nk3y.ia@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: option of kernel config
Message-ID: <20080702084812.69ea208d@lxorguk.ukuu.org.uk>
In-Reply-To: <f2ae95280807011525t250ff74k2f20d876860f34e6@mail.gmail.com>
References: <f2ae95280807011525t250ff74k2f20d876860f34e6@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 02:25:30 +0400
"Donkey Ia" <d0nk3y.ia@gmail.com> wrote:

> Please, excuse me - probably it's a very stupid question for this
> place, but i need to know - could you tell me please, ﻿which exactly
> option (or maybe options) of kernel config calls ide hard disks
> /dev/sdX instead /dev/hdX?

The old IDE layer (CONFIG_IDE) calls those ATA devices it recognizes
(most PATA, a few SATA) /dev/hd*, the newer Libata layer calls those it
handles (PATA/SATA) /dev/sd*. If you are using labels you can flip back
and forth quite easily.

Alan
