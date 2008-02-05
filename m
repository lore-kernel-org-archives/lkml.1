Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYBEV2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYBEV2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbYBEV2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:28:23 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39604 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760334AbYBEV2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:28:22 -0500
Date: Tue, 5 Feb 2008 21:20:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glenn Griffin <ggriffin.kernel@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
Message-ID: <20080205212017.5db50114@core>
In-Reply-To: <20080205203911.GA9891@2ka.mipt.ru>
References: <47a79d64.16538c0a.5b6a.ffffb0fe@mx.google.com>
	<20080205155558.GA23145@one.firstfloor.org>
	<c9e534200802051029u5d08cf6dm54866f769e362262@mail.gmail.com>
	<20080205200211.GA26150@one.firstfloor.org>
	<20080205203911.GA9891@2ka.mipt.ru>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How does syncookies prevent windows from growing?

Enabling them doesn't.

> Most (if not all) distributions have them enabled and window growing
> works just fine. Actually I do not see any reason why connection
> establishment handshake should prevent any run-time operations at all,
> even if it was setup during handshake.

Syncookies are only triggered if the system is under a load where it
would begin to lose connections otherwise. So they merely turn a DoS into
a working if slightly slower setup (and > 64K windows don't matter for
most normal users, especially on mobile devices).

