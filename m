Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYLHNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYLHNWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYLHNWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:22:11 -0500
Received: from broadrack.ru ([195.178.208.66]:35523 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYLHNWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:22:10 -0500
Date: Mon, 8 Dec 2008 16:22:07 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081208132207.GC15381@ioremap.net>
References: <20081205193432.290a6f1a@lxorguk.ukuu.org.uk> <20081205211223.GA8075@ioremap.net> <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com> <20081205212428.GB8075@ioremap.net> <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com> <20081206160927.GA498@ioremap.net> <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com> <20081206165634.GA2516@ioremap.net> <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com> <1228591926.3808.6.camel@nga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228591926.3808.6.camel@nga>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Dec 06, 2008 at 08:32:06PM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
> I don't know if it may have any bad side-effects. It moves the tty
> registration earlier, before we do pci, framebuffer, video, acpi
> registration.
> 
> It boots fine here with and without initramfs.
> 
> Maybe it makes the "dead" /dev/console in your initramfs working, then
> we at least know the problem.

Your patch fixes boot process in my case.

-- 
	Evgeniy Polyakov
