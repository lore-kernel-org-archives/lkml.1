Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYKDRlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYKDRlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYKDRlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:41:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53225 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751224AbYKDRlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:41:36 -0500
Date: Tue, 4 Nov 2008 17:41:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH] serial/8250: fix uninitialized warnings
Message-ID: <20081104174142.360a964a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081105022353.7CB0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081105022353.7CB0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 02:26:00 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> fix following warnings.
> 
> drivers/serial/8250.c: In function ‘serial8250_shutdown’:
> drivers/serial/8250.c:1612: warnings: ‘i’ may be used uninitialized in this function

NAK

This is an incorrect compiler warning. It's also one that current gcc
does not emit warnings for.

Alan
