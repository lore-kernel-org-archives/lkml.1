Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYHGM2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYHGM2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYHGM0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:26:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53405 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755039AbYHGMYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:24:42 -0400
Date: Thu, 7 Aug 2008 10:14:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: Aristeu Rozanski <arozansk@redhat.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] 8250: add support for DTR/DSR hardware flow control
Message-ID: <20080807101448.239fadc6@lxorguk.ukuu.org.uk>
In-Reply-To: <200808071032.16709.laurentp@cse-semaphore.com>
References: <20080806211438.GB20355@redhat.com>
	<200808071032.16709.laurentp@cse-semaphore.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please read the '[PATCH/RFC] 8250: Auto RS485 direction control' thread for background information. In a nutshell we need more than just CTS/RTS and DTR/DSR, and we don't have enough c_cflags bits. We will probably have to create a new ioctl.

Maybe - fortunately the kernel and user termios structure are now
independent so we can extend ktermios easily enough.

