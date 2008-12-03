Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYLCOwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYLCOwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYLCOw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:52:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60713 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751264AbYLCOw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:52:27 -0500
Date: Wed, 3 Dec 2008 14:52:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Luotao Fu <lfu@pengutronix.de>
Subject: Re: [PATCH]  remove isa stuff from smc91x driver
Message-ID: <20081203145235.05e1f461@lxorguk.ukuu.org.uk>
In-Reply-To: <1228315701-17240-1-git-send-email-l.fu@pengutronix.de>
References: <1228315701-17240-1-git-send-email-l.fu@pengutronix.de>
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

On Wed,  3 Dec 2008 15:48:21 +0100
Luotao Fu <l.fu@pengutronix.de> wrote:

> From: Luotao Fu <lfu@pengutronix.de>
> 
> ISA support in smc91x is incomplete. I doubt there're any smc91x isa card.
> This driver is greatly used on arm pxa platforms. Hence we remove the
> isa stuff from smc91x driver.

This makes no sense. It is protected by an ifdef anyway so doesn't affect
ARM

