Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZBHUO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZBHUO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZBHUOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:14:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37010 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752153AbZBHUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:14:16 -0500
Date: Sun, 8 Feb 2009 20:11:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
Message-ID: <20090208201125.49326bd2@lxorguk.ukuu.org.uk>
In-Reply-To: <200902082253.07438.sshtylyov@ru.mvista.com>
References: <200902082253.07438.sshtylyov@ru.mvista.com>
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

On Sun, 8 Feb 2009 23:53:07 +0400
Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> one last  time when there are exactly 3 trailing bytes.  Oh, and stop pointless
> swapping bytes to and fro as well by using io*_rep() which shouldn't byte-swap.

Nice - thats a very sneaky and clean way to do it but probably should be
commented or someone will "optimise" it one day ..
