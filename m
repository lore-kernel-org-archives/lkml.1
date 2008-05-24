Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbYEXSTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbYEXSTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbYEXSTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:19:02 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44529 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760650AbYEXSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:19:00 -0400
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
Message-Id: <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1211643245.31212.88.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sat, 24 May 2008 20:18:55 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org> <20080523164108.GA31545@uranus.ravnborg.org> <1211640377.540.14.camel@pmac.infradead.org> <20080524152214.GA12582@uranus.ravnborg.org> <1211642706.31212.85.camel@shinybook.infradead.org> <1211643245.31212.88.camel@shinybook.infradead.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>> Playing with it now. I fixed the mkdir thing by including $(objtree)
>> in the target.
>
> Here's what I have (on top of the git tree) now. I just need to sort  
> out
> the clean/mrproper behaviour -- and possibly should rename the korg
> firmware to firmware/korg/k1212.c_shipped?

so using "/" within the name parameter for request_firmware() is  
actually forbidden. I know that some driver authers think it is a good  
idea, but it is not.

I am actually working on a patch to make request_firmware() fail/warn  
when the name has a "/" in it.

You don't need to consider any deep nesting of firmware file names. It  
was never meant to be used like this.

Regards

Marcel

