Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165Ab0AIXij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0AIXij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602Ab0AIXij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:38:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:56589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0AIXii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:38:38 -0500
Date: Sat, 9 Jan 2010 15:41:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: Re: [PATCH 1/3] staging: make PCI device id constant
Message-ID: <20100109154115.152c55e1@infradead.org>
In-Reply-To: <4B490EC2.7050703@freemail.hu>
References: <4B490EC2.7050703@freemail.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 00:18:26 +0100
Németh Márton <nm127@freemail.hu> wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct pci_driver is constant in
> <linux/pci.h> so it is worth to make the initialization data also
> constant.


the PCI ID table can get written too via sysfs... making it const
breaks that...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
