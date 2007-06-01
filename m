Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbXFAV6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbXFAV6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXFAV6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:58:06 -0400
Received: from mx.laposte.net ([81.255.54.16]:7437 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbXFAV6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:58:05 -0400
Date: Fri,  1 Jun 2007 23:57:41 +0200
Message-Id: <JIZ905$469B6EF277FE655A66C9ACE2321FC036@laposte.net>
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
To: "djwong" <djwong@us.ibm.com>, "ebiederm" <ebiederm@xmission.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
X-XaM3-API-Version: 4.1 (B103)
X-SenderIP: 127.0.0.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There exists a similar scenario.  Set the IRQ affinity to a
bunch of
> CPUs, watch /proc/interrupts to see which CPU is actually
servicing the
> interrupts, then offline that CPU.  The kernel does not
reroute the IRQ
> to any of the other CPUs and the device also hangs.
>
> The furthest that I've dug is that it works on 2.6.17 and is
broken in
> 2.6.22-rc3 and 2.6.21.  Will git-bisect further, but I
wanted to know if
> anyone else has seen this sort of problem.  afaik, this
seems to happen
> with both IOAPIC and MSI interrupts, possibly more.
Hi,
As a side note, on my very old SMP machine, 2.6.20 correctly
load-balance IRQs across CPU but 2.6.21 not. I know that
in-kernel IRQ load balancer is marked as deprecated and
somewhat broken, but with your report it make me think it
could be a bug in the IRQ rerouting part in my case too and
not necessary in the load-balancer (decision) part.

Emmanuel.

---

Créez votre adresse électronique prenom.nom@laposte.net 
1 Go d'espace de stockage, anti-spam et anti-virus intégrés.

