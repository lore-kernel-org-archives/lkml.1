Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYF2Mzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYF2Mzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYF2Mzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:55:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52264 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754280AbYF2Mzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:55:43 -0400
Date: Sun, 29 Jun 2008 13:37:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@qumranet.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
Message-ID: <20080629133757.7d183385@lxorguk.ukuu.org.uk>
In-Reply-To: <48671FF6.1070501@qumranet.com>
References: <48661488.10304@gmail.com>
	<4866F6FE.9000503@goop.org>
	<486704AC.2090207@qumranet.com>
	<48671A12.90205@goop.org>
	<48671FF6.1070501@qumranet.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Applications should not assume that write() (or other syscalls) can't 
> return EINTR.  Not all filesystems have a bounded-time backing store.

Unix tradition (and thus almost all applications) believe file store
writes to be non signal interruptible. It would not be safe or practical
to change that guarantee.

Alan
