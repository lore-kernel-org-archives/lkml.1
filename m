Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYJNRax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYJNRax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYJNRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:30:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38595 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751877AbYJNRan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:30:43 -0400
Date: Tue, 14 Oct 2008 18:30:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@pol.net>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REVERT Request] VT Breakage
Message-ID: <20081014183002.059237e7@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0810140936360.3288@nehalem.linux-foundation.org>
References: <20081014115632.600a7506@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0810140936360.3288@nehalem.linux-foundation.org>
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

> So please check this patch. Also, can somebody please verify what the 
> _correct_ vt100 behavior is? The test-case was in the original commit, but 

Ahah a trick question - VT100 is monochrome. Colour VT as far as I can
tell (and while I have a genuine VT220 I don't have a non-clone colour
terminal[1]) behaves as we did *before* this changeset.

Alan
[1] And nobody send me one or Telsa will kill me
