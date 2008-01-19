Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbYASXHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbYASXHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYASXHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:07:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:60235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYASXHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:07:09 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: "Lars Callenbach" <lars.callenbach@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: linux device ordering at boot time
Date: Sun, 20 Jan 2008 00:06:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
References: <20080119185520.208350@gmx.net>
In-Reply-To: <20080119185520.208350@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801200007.00125.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/w3AybtkiCzMn1UevyR8zNZ8QeVsCQzsGzROB
 ZWI/bKmtjez5D/lZ6xsRtsxpasbOn6bcEIV70tA1SLCdtQ0sRl
 /OXRUZYqpfZ9Rj9zQSW9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 19. Januar 2008 schrieben Sie:
> I have a question concerning the ordering of devices during the boot
> process and I hope that the kernel mailing list is the right place for
> this question. In my computer are two raid controllers with one raid
> array connected to each of them (/dev/sda, /dev/sdb). In the debian
> 2.6.18 boot process the ordering is root @ /dev/sda and data are on
> /dev/sdb. This behaviour has changed in the plain 2.6.23.1 (and 2.6.23.8)
> kernel. The /dev/sd(a|b) devices have switched so that root @ /dev/sdb.
> So my standard fstab does not work. What determines the device ordering
> during the boot process? What is a workaround for this problem?

Well, it's a major pain in the a**. I've no idea, what reversed the order of 
PCI devices, but I had to disable the automatic dvb driver loading in order 
to get the picture back (dedicated vdr system with one FF and one budget 
card). I could have taken the route of exchanging the cards, but that would 
have been even more painful..

Oh well,
Pete

