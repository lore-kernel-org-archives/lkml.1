Return-Path: <linux-kernel-owner+w=401wt.eu-S1761718AbZAGXjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761718AbZAGXjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZAGXjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:39:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49834 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752401AbZAGXjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:39:12 -0500
Date: Wed, 7 Jan 2009 23:39:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Om <om.turyx@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 64 bit PCI access using MMX register -- how?
Message-ID: <20090107233929.60ef8d98@lxorguk.ukuu.org.uk>
In-Reply-To: <496534BC.4060603@gmail.com>
References: <496534BC.4060603@gmail.com>
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

One other problem: the kernel doesn't save the FPU state on context
switches or IRQ entry (takes far too long) so that will make a nasty mess.
