Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbYCXErm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbYCXErm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 00:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYCXErd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 00:47:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53635 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYCXEr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 00:47:29 -0400
Date: Mon, 24 Mar 2008 05:47:28 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: linux-kernel@vger.kernel.org
Subject: Re: your old menuconfig patch series, and select
In-Reply-To: <20080324040514.GC3321@khazad-dum.debian.net>
Message-ID: <alpine.LNX.1.10.0803240542030.27005@fbirervta.pbzchgretzou.qr>
References: <20080324040514.GC3321@khazad-dum.debian.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-03-24 05:05, Henrique de Moraes Holschuh wrote:
>
> In your menuconfig patch series to convert menu into menuconfig,
> you used "if <new menuconfig symbol" quite often.
>
> That causes serious issues with "select".  E.g. currently "select
> LEDS_CLASS" does not work, because it is inside a "if NEW_LEDS".
>[...]
> What's the best solution for this?  Drop the "if <menuconfig symbol>"
> and add lots of "depends on <menuconfig symbol>"?  Or hunt down every
> symbol selected inside an if and add the required select for the
> menuconfig symbol?

It "does not work" either if LEDS_CLASS is put outside of the if block
and instead gets a "depends on LEDS_CLASS".

So I am not sure what the problem you perceive really is, other than
"enabling A selecting B depending on (turned off) C"-is-allowed. :)
