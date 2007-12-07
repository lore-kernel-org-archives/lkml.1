Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbXLGOt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbXLGOt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXLGOtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:49:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39653 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751992AbXLGOtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:49:09 -0500
Date: Fri, 7 Dec 2007 14:44:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin =?UTF-8?B?TU9LUkVKxaA=?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.8: OOM killer kills wrong jobs
Message-ID: <20071207144413.02607168@the-village.bc.nu>
In-Reply-To: <47591183.8050402@ribosome.natur.cuni.cz>
References: <47591183.8050402@ribosome.natur.cuni.cz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 10:25:23 +0100
Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz> wrote:

> Hi,
>   first of all, sorry for not being up to date with how the OOM killer
> works. I think there used to be a kernel config option to disable
> OOM killer and instead kill the process which actually asks for the
> memory and supposedly caused the memory lack. That is what I would
> like to have on my system. I a have a 1GB RAM laptop and use t-coffee
> software from http://www.tcoffee.org/Projects_home_page/t_coffee_home_page.html
> to do some science. ;)

The OOM killer triggers where there is no way to fulfill a page request.
Something has to go and there is no real notion of "right" or "wrong"
process at that point.

You can either set no overcommit in which case you'll get failed malloc
and similar rather than allow overcommit, or you can set the OOM priority
of tasks yourself so that your specific app of choice always dies first.

Alan
