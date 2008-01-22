Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYAVW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYAVW1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbYAVW1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:27:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58983 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751785AbYAVW1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:27:41 -0500
Date: Tue, 22 Jan 2008 22:25:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Massive IDE problems. Who leaves data here?
Message-ID: <20080122222539.5643d6ae@lxorguk.ukuu.org.uk>
In-Reply-To: <fn5jsn$ful$1@ger.gmane.org>
References: <fn5ivo$ck2$1@ger.gmane.org>
	<47965138.8060603@garzik.org>
	<fn5jsn$ful$1@ger.gmane.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008 21:40:21 +0100
Manuel Reimer <Manuel.Spam@nurfuerspam.de> wrote:

> Jeff Garzik wrote:
> > If your IDE interface is complaining about BadCRC errors, then it's 
> > complaining about hardware problems (bad cable, etc.)
> 
> The cable already has been replaced three times. I even got sure to 
> *not* bend the cable. This all doesn't help.
> 
> May a bad cable really cause corrupted data?

Yes, or dodgy connectors or other problems. The CRC itself is computed by
the hardware each end so a BadCRC error really means the two ends
disagree about the data. 

That is *usually* a cable/electrical noise problem. It can be power and
it can occasionally show up if the software misprograms the timing so the
two ends are a bit out of sync.

Alan
