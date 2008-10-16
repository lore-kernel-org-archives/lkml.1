Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYJPMaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYJPMaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 08:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYJPM37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 08:29:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59876 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754013AbYJPM37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:29:59 -0400
Date: Thu, 16 Oct 2008 13:18:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC PATCH 2/5] hvc_console: Add tty driver flag
 TTY_DRIVER_RESET_TERMIOS
Message-ID: <20081016131843.1227da92@lxorguk.ukuu.org.uk>
In-Reply-To: <20081016110950.GA4125@cetus.boeblingen.de.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com>
	<20081014091413.003841094@linux.vnet.ibm.com>
	<20081014104025.517ae734@lxorguk.ukuu.org.uk>
	<20081016110950.GA4125@cetus.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For my network-based hvc backend, a tty_hangup() is caused by a disconnect.

If it is network backed then you probably do want
TTY_DRIVER_TERMIOS_RESET. For a normal serial type port getty is supposed
to sort the terminal settings out. So in your case it sounds like
resetting it is the right thing to do.

