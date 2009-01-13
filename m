Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZAMMKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZAMMKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZAMMKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:10:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56002 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752738AbZAMMK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:10:29 -0500
Date: Tue, 13 Jan 2009 12:10:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, zbr@ioremap.net, greg@kroah.com
Subject: ANDROID low memory killer register (was Linux killed Kenny,
 bastard!)
Message-ID: <20090113121038.3410de28@lxorguk.ukuu.org.uk>
In-Reply-To: <496C73DE.3030600@wpkg.org>
References: <496C73DE.3030600@wpkg.org>
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

> config ANDROID_LOW_MEMORY_KILLER
>          bool "Android Low Memory Killer"
>          default N
>          ---help---
>            Register processes to be killed when memory is low
> 
> available in Staging drivers / Android?

I believe they are related in the sense that both of them are
unneccessary and should not make the final kernel...

The /proc../oom_adj interface is again sufficient for this.
