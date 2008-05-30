Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYE3JuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYE3JuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbYE3JuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:50:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48982 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725AbYE3JuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:50:13 -0400
Date: Fri, 30 May 2008 10:36:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bertram Felgenhauer <int-e@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add workaround for bug in ASUS A7V600 BIOS (rev
 1005)
Message-ID: <20080530103605.1e56fac1@core>
In-Reply-To: <20080530012005.GA9514@zombie.inf.tu-dresden.de>
References: <20080530012005.GA9514@zombie.inf.tu-dresden.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 03:20:05 +0200
Bertram Felgenhauer <int-e@gmx.de> wrote:

> This BIOS claims the VIA 8237 south bridge to be compatible with VIA 586,
> which it is not.
> 
> Signed-off-by: Bertram Felgenhauer <int-e@gmx.de>

Looks fine to me

Acked-by: Alan Cox <alan@redhat.com>

>
> Amazingly I have a 2.6.23.8 kernel that somehow works fine ... I'll
> never understand why.

Probably because it has ACPI enabled and is picking ACPI IRQ routing in
preference ?

Alan
