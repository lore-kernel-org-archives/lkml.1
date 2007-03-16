Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXCPHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXCPHyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXCPHyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:54:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbXCPHyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:54:11 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Kconfig style question
To: Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 16 Mar 2007 08:53:53 +0100
References: <7Z7fc-4ZL-21@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HS7G6-0001Cr-19@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+AFTevBZP04blR5z/EOOG6pTXv3GVIl4jXJQr
 f4rStQv9EOQ9QOcmeK9pKtUPHyDdKhAAMEmRP2EKRahMUh2k6a
 vJFAJvsHefZNWEiQejbtg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@kernel.crashing.org> wrote:

> For source lines I've seen both:
> 
> source "arch/powerpc/platforms/52xx/Kconfig"
> 
> and
> 
> source arch/powerpc/platforms/85xx/Kconfig
> 
> Is there a preferred style?  Quotes or not?

$ find . -name Kconfig -exec grep ^source '{}' \;|grep \"|wc -l
    732
$ find . -name Kconfig -exec grep ^source '{}' \;|grep -v \"|wc -l
     44

-- 
Funny quotes:
18. Mind like a steel trap - rusty and illegal in 37 states.

Friﬂ, Spammer: yGspf@.6.7eggert.dyndns.org mgbem@Gtjunw.7eggert.dyndns.org
