Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674Ab0ADUWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0ADUWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 15:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336Ab0ADUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 15:22:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49977 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0ADUWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 15:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:reply-to:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Z1YelFN6gdNAMoxe0hRVsmlxuPHYdeVf+E2uWtG0K5OdL5bKSucW7CwPKVX2AWFwcb
         mmCSkcA/drlNbIaKdCMd5Gz4R3vKy+/nIcJ2N9d61Elc6oVoR8qQrolJsNjEI30kqR2c
         hOx/R3h5yTxWB+JMdNO68aq7QpM11EF2iA0fo=
From: Florian Fainelli <florian@openwrt.org>
Reply-To: Florian Fainelli <florian@openwrt.org>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] VLYNQ: add missing linux/irq.h include
Date: Mon, 4 Jan 2010 21:22:25 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-trunk-686; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <201001041838.51265.florian@openwrt.org> <20100104181228.GA28990@infradead.org>
In-Reply-To: <20100104181228.GA28990@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001042122.27360.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Le lundi 4 janvier 2010 19:12:28, Christoph Hellwig a écrit :
> On Mon, Jan 04, 2010 at 06:38:51PM +0100, Florian Fainelli wrote:
> > This patch adds the missing linux/irq.h header
> > which will trigger compilation errors on non-AR7
> > platforms (i.e: TI Davinci).
> 
> linux/irq.h should not be included by drivers.  It's an internal handler
> for the generic hardirq code.  All functions for use by drivers are in
> linux/interrupt.h

vlynq.c references definitions that are in linux/irq.h and not in 
linux/interrupt.h (like IRQ_TYPE_*), thus the include.
-- 
Best regards, Florian Fainelli
Email: florian@openwrt.org
Web: http://openwrt.org
IRC: [florian] on irc.freenode.net
-------------------------------
