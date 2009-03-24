Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbZCXPW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbZCXPW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZCXPWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:22:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54768 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754482AbZCXPWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:22:17 -0400
Date: Tue, 24 Mar 2009 15:22:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrey Panin <pazke@donpac.ru>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 01/30] disallow SERIAL_8250_PNP with SERIAL_8250_CONSOLE
Message-ID: <20090324152203.6a989d06@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324151034.GC6859@ports.donpac.ru>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
	<20090324140145.12735.29459.stgit@localhost.localdomain>
	<20090324151034.GC6859@ports.donpac.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch looks very controversial from my POV. Now distro people must decide
> what to enable SERIAL_8250_PNP or SERIAL_8250_CONSOLE. And no matter what you 

They do already, otherwise your machine crashes at boot.

> choose you'll get a regression, non-working serial console vs broken detection of
> perfectly working hardware like additional serial ports on industrial computers,
> notebook touchpads and finally old and dusty ISA PnP modems.
> 
> How widespread are these "known but hard to fix issues", to justify such drastic
> change ?

Any situation where you have a serial console on an ISAPnP device
explodes on boot. I do intend to find a better fix for this, but in the
meantime it is best that the quick fix goes in IMHO.
