Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXHWApV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXHWApV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbXHWApI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:45:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:28433 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXHWApH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:45:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=oHQUirCqFZ83mlrYQRop624wzGS2jAQtpCXiwXbM7ip8858OvyXE6VRNB7fwFrXgjCbPLYR4sMnKQbpbsjktSZYymkCWXvERvSs8Z1MgWnTsIArChtKWxIRk/JtGzdfJfQhCj9WPfrtoGkvYPT+et3Hj69HPu59CcV5JEhY/HdM=
Message-ID: <46CCD881.8060605@gmail.com>
Date: Thu, 23 Aug 2007 09:44:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andreas John <lists@aj.net-lab.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Conke Hu <conke.hu@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>	 <45F7E7E9.6010703@gmail.com>	 <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>	 <45F93888.1080207@gmail.com> <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com> <46CCA483.4080105@aj.net-lab.net> <46CCB23E.1000506@aj.net-lab.net>
In-Reply-To: <46CCB23E.1000506@aj.net-lab.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas John wrote:
> Hm,
> I should add that on 2.6.22-amd64 (ubuntu gutsy) the log entry is as
> follows:
> 
> ----8<------
> ata2.00 excetion Emask 0x40 SAct 0x0 SErr 0x800 action 0x2 frozen
> ata2.00 tag 0 cmd 0xea Emask 0x44 stat 0x40 err 0x0 timeout
> 1st FIS failed
> ----8<------

Please post full kernel boot log and the result of 'lspci -nn'.

-- 
tejun
