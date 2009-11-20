Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZKTOxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZKTOxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZKTOxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:53:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48509 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753823AbZKTOxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:53:23 -0500
Date: Fri, 20 Nov 2009 14:55:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Otavio Salvador <otavio@ossystems.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Vortex86SX: only works with irqpoll
Message-ID: <20091120145518.2ed0f2ed@lxorguk.ukuu.org.uk>
In-Reply-To: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 19:11:49 -0200
Otavio Salvador <otavio@ossystems.com.br> wrote:

> Hello,
> 
> I got this machine working booting it with "irqpoll" parameter however
> it drops the performance a lot and I'd like to try to fix the root
> problem of it.
> 
> Without 'irqpoll' the disk and network adaptor doesn't work.

That implies the IRQ routing is failing which usually but not always
means the tables in the firmware are wrong. The first step would probably
be to dump all the relevant PCI register space and the ACPI tables and
compare them with the IRQ routing documentation for the chipset.

Actually no - thats step 2, step 1 is asking the vendor if there is
updated firmware to fix IRQ delivery problems
