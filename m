Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbYHIVHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbYHIVHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYHIVHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:07:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59164 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753885AbYHIVHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:07:42 -0400
Date: Sat, 9 Aug 2008 21:50:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@osdl.org>, Fritz Elfert <fritz@isdn4linux.de>,
       Karsten Keil <kkeil@suse.de>, isdn4linux@listserv.isdn4linux.de,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
Message-ID: <20080809215020.1bb602e7@lxorguk.ukuu.org.uk>
In-Reply-To: <489DD669.2090207@keyaccess.nl>
References: <489DD669.2090207@keyaccess.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Aug 2008 19:39:53 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> Grabbing ISA bus resources without anything or anyone telling us we
> should can break boot on randconfig/allyesconfig builds by keeping
> resources that are in fact owned by different hardware busy and does
> as reported by Ingo Molnar.

Not an interesting case, and also wrong in the modular case where loading
the module is a direct user action indicating clear intent to use the
functionality *as is*.

NAK this one too.

At the very least make the requirement to say "like please run for real"
dependant on it not being built modular - which is what was done for the
last ones that were twiddled to keep Ingo amused.

Alan
