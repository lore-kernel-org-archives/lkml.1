Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004Ab0AZJXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab0AZJXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790Ab0AZJXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:23:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48668 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0AZJXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:23:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GYZHGznvTGjZT1GNdSSkJV4UJIxR3RDbD5FE/OF9r5rZLbIXO50PsZ89zpt14FMzUv
         LpeO9gGNpBX8J4ItYtNREbeGmsCCCtUUP0MnqTzxBWV20kNnpyf3QZj0a1zMKY6rvFTQ
         AO6/O65EDiyixrArSgEk0vekOxkYHb1NZJ33o=
MIME-Version: 1.0
In-Reply-To: <20100125.165644.197238824.davem@davemloft.net>
References: <20100125.165644.197238824.davem@davemloft.net>
Date: Tue, 26 Jan 2010 12:23:06 +0300
Message-ID: <a4423d671001260123r7013a92fqb007e4f255e8b3ba@mail.gmail.com>
Subject: Re: [GIT]: Sparc
From: Alexander Beregalov <a.beregalov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

> 7) IRQ ->set_affinity() using wrong cpu mask, thanks to Ben H. for
>   noticing.
>      sparc64: Fix IRQ ->set_affinity() methods.

This commit breaks UP build

arch/sparc/kernel/irq_64.c: In function 'sun4u_irq_enable':
arch/sparc/kernel/irq_64.c:286: error: 'struct irq_desc' has no member
named 'affinity'
arch/sparc/kernel/irq_64.c: In function 'sun4v_irq_enable':
arch/sparc/kernel/irq_64.c:362: error: 'struct irq_desc' has no member
named 'affinity'
arch/sparc/kernel/irq_64.c: In function 'sun4v_virq_enable':
arch/sparc/kernel/irq_64.c:425: error: 'struct irq_desc' has no member
named 'affinity'
