Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbYFPKHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbYFPKHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYFPKH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:07:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36114 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbYFPKH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:07:26 -0400
Date: Mon, 16 Jun 2008 10:49:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jmcgowan@inch.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: minicom and kernel 2.6.25.1 (at least) (DTR)
Message-ID: <20080616104955.4200f336@lxorguk.ukuu.org.uk>
In-Reply-To: <200806152316.m5FNG9E3006939@Ettarre>
References: <200806152316.m5FNG9E3006939@Ettarre>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I've seen a couple of reports of this but so far failed to find any
explanation as to why it is behaving oddly. The serial core code raises
DTR when an open completes and when the user asks it so at the moment
I've not managed to duplicate the bug, although from the several reports
it seems real enough.

What type of serial port are you using ?
