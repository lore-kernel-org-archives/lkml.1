Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYFBQMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYFBQMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYFBQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:12:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33887 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753687AbYFBQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:12:09 -0400
Date: Mon, 2 Jun 2008 16:56:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Brandon Philips <bphilips@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
Subject: Re: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
Message-ID: <20080602165649.01c2c680@core>
In-Reply-To: <1212421611.16924.246.camel@pmac.infradead.org>
References: <200804241931.m3OJVQiR022368@hera.kernel.org>
	<1212421611.16924.246.camel@pmac.infradead.org>
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

> Please can we revert the addition of _DEPRECATED to these ioctl
> definitions. Perhaps we can add a runtime warning if they actually get
> used? Or a compile-time warning if we can manage that?

Can you clarify the problem here ? Is this compile breakage as it appears
(See 'do not include kernel headers in user space apps') or runtime ?

Alan
