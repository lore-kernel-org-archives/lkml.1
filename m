Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbXCLVBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbXCLVBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXCLVBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:01:30 -0400
Received: from twin.jikos.cz ([213.151.79.26]:50902 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbXCLVBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:01:30 -0400
Date: Mon, 12 Mar 2007 22:00:23 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45F57F94.6010502@gmail.com>
Message-ID: <Pine.LNX.4.64.0703122157550.14144@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0703121100460.2489-100000@iolanthe.rowland.org>
 <45F57F94.6010502@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed CC list a bit)

On Mon, 12 Mar 2007, Jiri Slaby wrote:

> > >      UHCI: Eliminate asynchronous skeleton Queue Headers
> > Post it along with the usbmon log, and I'll try to figure out what happened.
> Here it comes:
> USBMON:
> f7525b40 1832950485 C Ii:004:01 0 8 = 00005300 00000000
> f7525b40 1832950517 S Ii:004:01 -115 8 <
> f7525140 1832950540 S Co:004:00 s 21 09 0200 0000 0001 1 = 01
> f7525140 1832952485 C Co:004:00 0 1 >
> Corresponds to numlock; 7; numlock; 7.

Jiri,

thanks. Could you also please redo the test with the offending uhci patch 
reverted and send the output of a working situation?

Thanks,

-- 
Jiri Kosina
