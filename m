Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYFZPld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYFZPld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYFZPlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:41:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53234 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751061AbYFZPlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:41:24 -0400
Date: Thu, 26 Jun 2008 16:23:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: keyspan_pda.c use of keyspan_pda_get_modem_info
Message-ID: <20080626162346.5c324701@lxorguk.ukuu.org.uk>
In-Reply-To: <4863AD33.3070005@panasas.com>
References: <4863AD33.3070005@panasas.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In these two call sites the callers bail out if
> keyspan_pda_get_modem_info return value is < 0

I don't think that is what the compiler is warning about.

We error on rc < 0
We use the returned status on rc >= 0

We set the returned status on rc > 0

So the rc = 0 case is broken and gcc seems to be correct about that
