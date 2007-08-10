Return-Path: <linux-kernel-owner+w=401wt.eu-S934561AbXHJMoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbXHJMoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761317AbXHJMoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:44:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:34914 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbXHJMn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=iVWkS87thUJ5uyPpf2mn5O05CHVgVplHiWmmZXDyI7tZJjtqQJzDznYrFg9SntUjvibu9cJgW/IAqQHE63QbomkAzuwAatc2SWZoe0MJcF7y08gpQ4C9AjMzljbSz+2IG8Grv/imwyvBES9GyKGTtv7NwsVvs3U8dCLMHHbNbNU=
Message-ID: <46BC5D18.9060906@googlemail.com>
Date: Fri, 10 Aug 2007 14:42:00 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org> <46BC3CB1.2090503@googlemail.com>
In-Reply-To: <46BC3CB1.2090503@googlemail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting that with gcc 4.2.1 :


...

  CC      drivers/usb/host/ohci-hcd.o
  CC      drivers/usb/misc/usbled.o
  CC      drivers/usb/core/driver.o
In file included from drivers/usb/host/ohci-hcd.c:86:
drivers/usb/host/ohci-dbg.c: In function 'show_registers':
drivers/usb/host/ohci-dbg.c:620: warning: the address of 'next' will always evaluate as 'true'
drivers/usb/host/ohci-dbg.c:639: warning: the address of 'next' will always evaluate as 'true'

...


config : http://194.231.229.228/kernel/mm/2.6.23-rc2-mm2/randconfig-auto-5


