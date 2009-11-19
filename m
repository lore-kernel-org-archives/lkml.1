Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZKSTAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZKSTAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZKSTAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:00:44 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:61763 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZKSTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=LVLnx8hRD4kSpKvGghrQk63z9y5gDXjbLzOkPvKnRwbde789pWsbhUIGTAGbZ2CTr1
         LNGHHpla0DfQNt2EI+Wmnb6+NcaxFLZ6ILKxJbVci953mgUYaGU7Fr0fhruZMWHQgWbj
         mk+4dWE+4laFzSlht1U5ne6z2CEyovNGcYcHY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 19:58:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911191852.23061.bzolnier@gmail.com> <20091119182132.5155f819@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119182132.5155f819@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911191958.34247.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 19:21:32 Alan Cox wrote:
> > Fixed where?  I posted the patch as soon as I noticed the problem.
> 
> Its not posted because unlike you I don't post patches as soon as I
> notice them. I test them first. Which is why for example I discovered the
> bug in the drivers/ide one. Did you check the vendor driver and then
> stick 40 and 80 wire cables on the system to check the bits on a 3x2N ?
> No I didn't think so. You see if you had you'd have discovered something

I did check the vendor driver but I don't have 3x2N to test it so posting
patch ASAP to make it possible for other people to verify it was the best
course of action and completely justified.  Don't you agree?

> else. You'd have discovered another bug in the old IDE one. The driver

You mean 'another' like yours _three_ year old 'one'? :)

> code for these chips isn't reliable and doesn't work at all in some cases.
> 
> > Told me about it?  
> 
> Yes - or do you only write replies not read them ?

Well, yours have low SNR and I value my time..

> NAK - the patch is inadequate. The procedure in the vendor driver does

Patch is completely adequate in what it tries to achieve (fixing three year
old problem with testing the bit for the wrong port) and you could have made
an incremental fix for 'a second issue' easily.

However I'm not into NIH so your patch is also fine and a more complete one.

>     pata_hpt3x2n: Fix cable detection
>     
>     The version inherited from drivers/ide doesn't work on the newer chipsets
>     at least not reliably. The vendors own driver uses a different process and
>     that one appears to produce plausible numbers.

Well, maybe except how you decided to 'skip' in the patch description
the part about how you have managed to introduce a regression three years
ago into already unreliable cable detection taken from hpt366.. ;)

-- 
Bartlomiej Zolnierkiewicz
