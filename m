Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbYH1VGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbYH1VGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYH1VG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:06:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53654 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754547AbYH1VG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:06:26 -0400
Date: Thu, 28 Aug 2008 21:48:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, greg@kroah.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
Message-ID: <20080828214822.1052392f@lxorguk.ukuu.org.uk>
In-Reply-To: <48B6EF98.4070008@kernel.org>
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
	<1219945263-21074-6-git-send-email-tj@kernel.org>
	<20080828175116.GB18461@kroah.com>
	<48B6E79E.6020702@kernel.org>
	<48B6E801.9080102@kernel.org>
	<E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>
	<48B6EBBD.6050406@kernel.org>
	<E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>
	<48B6EF98.4070008@kernel.org>
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

> Well, it's only 240 lines with good amount of comments and iovec copying
> function.  The ioctl itself isn't too complex.  I'm a bit skeptical
> about direct access.  It can easily introduce security vulnerabilities
> as there really is no way to hold a pid.

Agreed entirely. If and only if there is a future problem with
performance someone can introduce a method for the client to pre-describe
certain ioctls in terms of number/length/read/write.

Alan
