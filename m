Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbXKLPLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbXKLPLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbXKLPLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:11:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:35393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbXKLPLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:11:35 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 7/13] Char: nozomi, remove struct irq
Date: Mon, 12 Nov 2007 16:11:31 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <2694611355132233895.slaby@pripojeni.net>
In-Reply-To: <2694611355132233895.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121611.32544.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:47:31, you (Jiri Slaby) wrote:
> nozomi, remove struct irq
> struct irq (named as my_irq) is used only in ISR and its called functions.
> We might silently use u16 variable on stack and remove all references to
> this structure. This is the first step of struct nozomi_devices removal.

As this u16 is kind of local (just handed around from interrupt_handler) and
the structs value was anyway overwritten always/on every interrupt call
this seems to be totally ok.
Just to be sure i ran a whole testseries and it really didn't show anything
unusual => So, applied without changes.

Thanks,
Frank
