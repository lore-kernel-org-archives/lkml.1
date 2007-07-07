Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbXGGQuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbXGGQuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 12:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXGGQuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 12:50:00 -0400
Received: from h155.mvista.com ([63.81.120.155]:55681 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752336AbXGGQt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 12:49:59 -0400
Message-ID: <468FC4AC.9030701@ru.mvista.com>
Date: Sat, 07 Jul 2007 20:51:56 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
References: <20070707094852.9473.21013.stgit@localhost.localdomain> <200707071419.52650.arnd@arndb.de>
In-Reply-To: <200707071419.52650.arnd@arndb.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

>>This adds support for MMIO IDE device like CompactFlash 
>>in TrueIDE mode.

>>Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com> 
>>Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

> Hmm, are we still adding new IDE drivers? Do you also have a

    Yes, why not?

> driver for the new libata layer?

    No (sorry for replying for Vitaly but I know the situation).

> I think it would even be simpler to do.

    Wel have no interest in it right now.

> You could also make it an of_platform_driver at the same time
> instead of adding more cruft to fsl_soc.c. Since we're already

    That's a fair point (and fsl_soc.c doesn't seem proper place anyway).

> about to add the electra_ide.c driver in 2.6.23, I guess there
> should really be _one_ driver that is able to handle all
> of_device based ATA hosts.

    One driver to rule them all. :-)
    That may be not so simple as it seems...

MBR, Sergei
