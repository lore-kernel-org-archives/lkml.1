Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYFPKbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYFPKbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYFPKbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:31:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44893 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbYFPKbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:31:12 -0400
Date: Mon, 16 Jun 2008 11:13:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "R.L. Horn" <lists@eastcheap.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080616111329.3ae97879@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.1.00.0806150032050.1283@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal>
	<20080614102900.6830ed46@lxorguk.ukuu.org.uk>
	<alpine.LNX.1.00.0806150032050.1283@hani.compact.internal>
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

> But, then, what is the relationship between CLOCAL and DTR/RTS supposed to 
> be?  Presumably, it should prevent a SIGHUP from being raised when DSR 
> goes low, but beyond that, it all seems rather ill-defined.  Throw in B0, 

CLOCAL is defined to "ignore modem control lines"

> which the SUS strongly implies should unconditionally lower DTR and RTS, 
> and the CRTSCTS flag, and the waters really get murky.  It looks to me 
> like the only thing you can say for certain is that CLOCAL will cause DSR 
> to be ignored...and for anything else you're on your own.

Whatever it implies the behaviour should not have changed between 2.6.24
and 2.6.25. Nobody AFAIK sat down and decided to change it.

> 
> Mind you, all this just suggests that POSIX kinda sucks, which is hardly 
> an earth-shattering revelation.

Standards are part written spec and a large part an existing tradition
around that standard. The tradition is often the most important bit.

Alan
