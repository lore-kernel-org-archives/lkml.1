Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYH1Xua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYH1Xua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYH1XuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:50:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53339 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753418AbYH1XuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:50:21 -0400
Date: Fri, 29 Aug 2008 00:32:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@kernel.org>,
       Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Takashi Iwai <tiwai@suse.de>,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
Message-ID: <20080829003257.531cc77a@lxorguk.ukuu.org.uk>
In-Reply-To: <48B736E7.5000407@kernel.org>
References: <48B6F711.1040604@kernel.org>
	<20080828200120.GA16462@cs181140183.pp.htv.fi>
	<20080828221828.GB2855@kroah.com>
	<48B72F53.9080109@kernel.org>
	<20080828231426.GA15284@kroah.com>
	<48B736E7.5000407@kernel.org>
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


> serial ports as ptys+userspace a much more capable replacement.  It's 
> not trivial, though, because the interpretation of the BREAK has to be 
> done when received, not when sent, which means supporting a 257th value 
> in the underlying buffer setup.

That bit of the problem is trivial. Its the rest of the behavioural
differences that are more of a nightmare - parity, flow control
differences, modem line emulation, being able to hook into things like
ldisc change/termios change.

Break is about a half hour job.

Alan
