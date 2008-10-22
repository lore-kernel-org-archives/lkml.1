Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYJVKGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYJVKGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYJVKGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:06:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44726 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752950AbYJVKGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:06:36 -0400
Date: Wed, 22 Oct 2008 11:06:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make static
Message-ID: <20081022110642.5140c670@lxorguk.ukuu.org.uk>
In-Reply-To: <48FE6A75.5080004@gmail.com>
References: <48FE6A75.5080004@gmail.com>
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

> Building an allnoconfig, sparse asked whether these could be static, so I checked,
> and they are only used in the file where they are declared. This means that they
> can be static, am I forgetting something? This was build and checkpatch tested.

The tty ones look correct. The tty_io one is already fixed (Jason beat
you to it). The pty one is a result of some code tidying and correct as
is the vt one. I'll merge the vt/pty bits

Alan
