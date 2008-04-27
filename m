Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbYD0XfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbYD0XfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYD0XfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:35:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33863 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbYD0XfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:35:13 -0400
Message-ID: <48150DA3.5020606@garzik.org>
Date: Sun, 27 Apr 2008 19:34:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <20080427214837.GA11631@elte.hu>	<1209335660.3801.79.camel@localhost.localdomain>	<4815009C.2010809@garzik.org> <20080427.154620.177583216.davem@davemloft.net> <48150392.6040508@zytor.com>
In-Reply-To: <48150392.6040508@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Arguably, the right thing is to not even have ioremap() anymore, just 
> ioremap_{cache,nocache,wc} and consider any unconverted ioremap() as a 
> flag to audit that particular piece of code.

Seems like a sane plan...  last handful might be tough, though.

	Jeff


