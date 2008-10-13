Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbYJMKkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbYJMKkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbYJMKkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:40:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51197 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753225AbYJMKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:40:24 -0400
Date: Mon, 13 Oct 2008 11:40:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] tty: remove the BKL in n_tty.c
Message-ID: <20081013114010.063201a8@lxorguk.ukuu.org.uk>
In-Reply-To: <874p3gsrvt.fsf@basil.nowhere.org>
References: <20081013084719.03972D1B9DE@perso1.free.fr>
	<874p3gsrvt.fsf@basil.nowhere.org>
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

> I suppose Alan did it already

Credit goes to Joe Peterson not me. I looked at it several times and
thought this will not be fun I'll do it later. In the meantime Joe
debugged where others feared to tread and did all the work to drop the
BKL out of those paths.
