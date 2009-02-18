Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZBRAbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZBRAbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZBRAbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:31:33 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:55770 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbZBRAbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:31:31 -0500
X-Greylist: delayed 39251 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 19:31:27 EST
Message-ID: <499B56D3.3080701@free.fr>
Date: Wed, 18 Feb 2009 01:31:15 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-input@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: USB mouse won't work after resume.
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au> <200902171135.13329.oliver@neukum.org> <499ABD80.9020904@free.fr> <200902172142.57302.oliver@neukum.org>
In-Reply-To: <200902172142.57302.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17.02.2009 21:42, Oliver Neukum a écrit :
> Am Tuesday 17 February 2009 14:37:04 schrieb Laurent Riffard:
>> Le 17.02.2009 11:35, Oliver Neukum a écrit :
>>> Am Tuesday 17 February 2009 10:55:57 schrieb Laurent Riffard:
>>>> My USB mouse won't work after suspend to disk and resume. I must unload and reload the ohci_hcd module to get it back.
>>> Please recompile your kernel with CONFIG_USB_DEBUG and
>>> send me your dmesg.
>>>
>>> 	Regards
>>> 		Oliver
>>>
>> Here is it:
>>
> 
> Please try the attached patch.
> 
> 	Regards
> 		Oliver
> 

This patch does fix the behaviour, my USB mouse now works after suspend/resume. Thanks.

Tested-by: Laurent Riffard <laurent.riffard@free.fr>
~~
laurent
