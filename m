Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbXIXKXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbXIXKXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXIXKXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:23:13 -0400
Received: from ns.suse.de ([195.135.220.2]:41013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbXIXKXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:23:12 -0400
Message-ID: <46F7900F.6010105@suse.de>
Date: Mon, 24 Sep 2007 12:23:11 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Matthew Wilcox <matthew@wil.cx>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] debloat aic7xxx and aic79xx drivers
References: <200708311613.59666.vda.linux@googlemail.com> <200708311615.54991.vda.linux@googlemail.com> <200708311616.36251.vda.linux@googlemail.com>
In-Reply-To: <200708311616.36251.vda.linux@googlemail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Friday 31 August 2007 16:15, Denys Vlasenko wrote:
>> On Friday 31 August 2007 16:13, Denys Vlasenko wrote:
>>> Attached are three patches which fix that:
>>>
>>>    text    data     bss     dec     hex filename
>>>  261433   50018    1172  312623   4c52f linux-2.6.23-rc1.org.t/drivers/scsi/aic7xxx/built-in.o
>>>  199654   50018    1172  250844   3d3dc linux-2.6.23-rc1.aic.t/drivers/scsi/aic7xxx/built-in.o
>>>  184014   21314    1172  206500   326a4 linux-2.6.23-rc1.aic1.t/drivers/scsi/aic7xxx/built-in.o
>>>  202378    2850    1172  206400   32640 linux-2.6.23-rc1.aic2.t/drivers/scsi/aic7xxx/built-in.o
>>>
>>> 1-debloat.patch    deinlines a lot of functions
>>> 2-addstatic.patch  adds statics, #ifdefs out huge amount of unused code, adds consts
>>> 3-addconst.patch   adds more consts
Have you checked the sequence assembler, too? It doesn't help much to edit the *.shipped files;
someone might just run the assembler again and we're back to square one ...

Apart from this:

Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
