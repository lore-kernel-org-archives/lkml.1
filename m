Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbXITRwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbXITRwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXITRwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:52:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:13366 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbXITRwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Q3ViSfvcDuHomsw4cRODNz1Y0cuNi5WIxbOYisRD8mXx00k4Wbt3qps1st8hL/YrngHknNiYmCLUoU76OjXZLWbzswgkR7uPv71df2l2HA3lAj6nXxA3aylCn4xM4i6emWgnFQb9dPjY9WElbElEbPKbEfFiVg5aZ4ye7fJa8Wk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: [PATCH -mm] sb16: Shut up uninitialized var build warning
Date: Thu, 20 Sep 2007 18:52:11 +0100
User-Agent: KMail/1.9.1
Cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030143550.29617@enigma.security.iitk.ac.in> <46DB33D0.40204@gmail.com>
In-Reply-To: <46DB33D0.40204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709201852.11497.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2007 23:06, Rene Herman wrote:
> On 09/02/2007 10:15 PM, Satyam Sharma wrote:
> 
> > sound/isa/sb16/sb16.c: In function ‘snd_sb16_isa_probe’:
> 
> Blah. Your message has:
> 
> 	Content-Type: TEXT/PLAIN; charset=iso-2022-jp
> 
> This apparently is caused by a combination of GCC using groovy UTF tickmarks 
> in its error messages when in a UTF locale and alpine believing it to be a 
> great idea to automatically try for the "simplest" character set it can 
> encode the content in. No idea why that means that iso-2022-jp is picked, 
> but it is.
> 
> While I could actually read the message this time you should see what 
> iso-2022-jp does to my font. It's scary. Best solution as far as I'm 
> concerned is slap a few GCC developers (not that it wil help, but it'll 
> certainly feel good) and then teach alpine to go for UTF-8 directly if 
> US-ASCII won't do.

rotfl.

Kindly give me permission to convert your email into gcc bugreport
and/or to forward it to gcc mailing list.
--
vda
