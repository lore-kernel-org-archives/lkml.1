Return-Path: <linux-kernel-owner+w=401wt.eu-S1763485AbYEFPcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763485AbYEFPcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbYEFPbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:31:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38246 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756239AbYEFPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:31:53 -0400
Date: Tue, 6 May 2008 16:20:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Shaohua Li <shaohua.li@intel.com>, Holger Macht <hmacht@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080506162049.237af49c@core>
In-Reply-To: <20080506151846.GA22828@khazad-dum.debian.net>
References: <20080505202508.GA3690@homac>
	<20080506091522.GA4378@homac>
	<1210065811.12668.1.camel@sli10-desk.sh.intel.com>
	<20080506151846.GA22828@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 12:18:46 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Tue, 06 May 2008, Shaohua Li wrote:
> > The bay driver is duplicated with libata, I thought we should delete it.
> > See bug http://bugzilla.kernel.org/show_bug.cgi?id=9526
> 
> The bay driver is currently useless, BUT it should handle a lot of stuff
> libata won't, such as bay batteries, bay floppies, and anything else in
> a bay that is not a hard disk.

The bay driver needs to become a service that hands out bay events to
all the other drivers for that to happen.
