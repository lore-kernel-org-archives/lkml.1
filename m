Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbXIUJYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbXIUJYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXIUJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:24:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65247 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbXIUJYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:24:48 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Adrian McMenamin <lkmladrian@gmail.com>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 21 Sep 2007 11:24:26 +0200
References: <95y0Q-7JD-5@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IYekM-0000cx-8g@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/dUXmeQNbGX9GSgdb2NFRq8nmJ7TK78SfqGSm
 92LR7xeNVjifIFpvPVD5V3vHd0jIu62Ax0ED5EhEkiGJpmtxN5
 nBO4fAOW0Y7gSEoyfWTXg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  Move the hadover message to after the boot console has been released to
> avoid bad interactions between it and the real console.

This message is usefull if the handover fails, therefore it should be printed
on the boot console, while successfull switchover is implied by having any
output on the real console. Isn't it?
-- 
Our last fight was my fault: My wife asked me "What's on the TV?"
I said, "Dust!"

Friﬂ, Spammer: xeSibW3yen@kqxsenc.7eggert.dyndns.org
