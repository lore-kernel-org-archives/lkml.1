Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYDXV20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYDXV20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYDXV2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:28:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47404 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751205AbYDXV2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:28:14 -0400
Date: Thu, 24 Apr 2008 21:58:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] socket, socketpair w/flags, accept4
Message-ID: <20080424215858.771f718a@the-village.bc.nu>
In-Reply-To: <200804241820.m3OIKlMK017580@devserv.devel.redhat.com>
References: <200804241820.m3OIKlMK017580@devserv.devel.redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The code changes are really minimal.  And don't get too hung up on the
> internal name of the syscall.  I think accept4 is more desriptive than
> paccept since a) suffixes more easily indicate derived functionality
> and b) the 4 actually indicates to the initiated what has changed.

Names can be argued about separately to functionality. Can we also get
the behaviour of flag inheritance and other stuff defined in any future
API spec for this so it is consistent across platforms too - that will
also let the new accept be used in the longer term to make portable code
easier.

Alan
