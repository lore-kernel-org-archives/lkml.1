Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbYGJTeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYGJTeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYGJTeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:34:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYGJTeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:34:13 -0400
Date: Thu, 10 Jul 2008 16:33:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
Message-ID: <20080710163354.0cf75932@gaivota>
In-Reply-To: <200807102112.09532.mb@bu3sch.de>
References: <200807101914.10174.mb@bu3sch.de>
	<20080710160258.4ddb5c61@gaivota>
	<200807102112.09532.mb@bu3sch.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.4; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 21:12:09 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> > One alternative would be to make the gpio driver dependent of !VIDEO_BT848.  
> 
> +config GPIO_BT8XX
> +       tristate "BT8XX GPIO abuser"
> +       depends on PCI && VIDEO_BT848=n

Seems fine to me.


Cheers,
Mauro
