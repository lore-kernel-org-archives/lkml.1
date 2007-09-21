Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXIUHBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXIUHBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 03:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXIUHBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 03:01:24 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:52258 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbXIUHBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 03:01:23 -0400
Date: Fri, 21 Sep 2007 16:00:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fwd: [PATCH 0/3] Add Maple bus support for the SEGA Dreamcast - repost
Message-ID: <20070921070057.GB7053@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
	Greg KH <greg@kroah.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>
References: <8b67d60709200429y2118d943rcddf2b0fa31a5502@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60709200429y2118d943rcddf2b0fa31a5502@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 12:29:40PM +0100, Adrian McMenamin wrote:
> The Maple bus is SEGA's proprietary serial bus for peripherals
> (keyboard, mouse, controller etc). The bus is capable of some
> (limited) hotplugging and operates at up to 2 M/bits.
> 
I've applied this and the header changes with a bit of tidying. Dmitry can
merge the keyboard driver in the input tree at any time, the Kconfig
dependency will just prevent it from showing up until the SH tree has
merged.
