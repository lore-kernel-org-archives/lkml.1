Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYEaPkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYEaPkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbYEaPiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49773 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754437AbYEaPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:25 -0400
Date: Sat, 31 May 2008 16:23:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Jenkins <aj504@cs.york.ac.uk>
Cc: Chris Frey <cdfrey@foursquare.net>, linux-kernel@vger.kernel.org
Subject: Re: OOM policy, overcommit control, and soft limits
Message-ID: <20080531162341.4e183a09@core>
In-Reply-To: <3849b91c-cfca-4126-b14b-aa6d2b4b10b3@m45g2000hsb.googlegroups.com>
References: <azwvH-5QW-5@gated-at.bofh.it>
	<3849b91c-cfca-4126-b14b-aa6d2b4b10b3@m45g2000hsb.googlegroups.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In other words, I reckon I have on the order of a gigabyte of virtual
> address space, which has been malloc'ed or equivalent, but is not used
> and therefore requires no memory resource (ram or swap).

No need to reckon. The committed_as in the proc file should give a rough
value.

Alan
