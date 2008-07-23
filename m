Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbYGWH7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbYGWH7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYGWH6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:58:53 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:45828 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYGWH6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:58:52 -0400
Message-ID: <4886E540.2070106@keyaccess.nl>
Date: Wed, 23 Jul 2008 10:01:04 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Fabio Comolli <fabio.comolli@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: New conflict message in latest GIT
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>	 <48863C46.1060704@keyaccess.nl> <48863FB4.9080500@keyaccess.nl> <b637ec0b0807230017w39ecd5bapc9a6afe29a39d5f3@mail.gmail.com>
In-Reply-To: <b637ec0b0807230017w39ecd5bapc9a6afe29a39d5f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-07-08 09:17, Fabio Comolli wrote:

>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc8/2.6.26-rc8-mm1/broken-out/pnp-have-quirk_system_pci_resources-include-io-resources.patch
> 
> I did not add it manually for sure. By the way, I don't see any ACPI
> related problems with this kernel.

You can just look at drivers/pnp/quirks.c:quirk_system_pci_resources() 
and see if it's still IORESOURCE_MEM only (current linus) or includes 
IORESOURCE_IO resources as per that patch.

Had a momentary notion that if we specifically exclude ACPI in favour of 
PCI as that patch does this could _cause_ the message -- before, the PCI 
smbus driver just would've failed but perhaps you don't even have such a 
driver or something.

Probably way of base. Just had a deja vu to my own soundcard trouble.

Rene
