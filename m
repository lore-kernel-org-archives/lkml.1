Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbXF2FWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbXF2FWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXF2FWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:22:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:40416 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbXF2FWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rfwdA8bTgx1R9zZppXNpAPPtkmpxvQpviFpajjLqBWvDgUlQ1IrH2awHb49MK2qqdST89PSW5c0jzh8NQxa9sidLtx2FGcr/dKEPXHVViX0sTepsFD494areqjjlQ8gCtg2RYKHl30itPo3hbsqGiuMyZksCASy4JHW8JhPhbK4=
Message-ID: <3ae72650706282222u6e5094ffp8e77c0735f39e43d@mail.gmail.com>
Date: Fri, 29 Jun 2007 07:22:44 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB card reader and HAL
In-Reply-To: <20070628214351.GA9632@DervishD>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070628214351.GA9632@DervishD>
X-Google-Sender-Auth: 71b72828ec68cafc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, DervishD <lkml@dervishd.net> wrote:
>     I have a new card reader (internal) but I've tested with my old one
> too: the same happens. I have a do-it-yourself linux box, self compiled
> kernel 2.6.19.5 (by now).
>
>     When I insert a card in the reader, it is not detected, no udev
> event is generated and I have to do things like "hdparm -z /dev/sda" to
> "probe" the card. Moreover, I have to do the same when removing the card
> or the /dev/sdaX nodes are not deleted.
>
>     Is HAL the only way of making it work? Is there any CONFIG_ thing
> I've forgotten in my kernel?
>
>     I've tested with Ubuntu and it works perfectly, and that's why I
> think this may be HAL related (I don't have HAL installed, Ubuntu has).

You have to open() the device node to trigger events from the kernel,
the kernel itself will not do that for you. HAL polls the device every
few seconds.

Kay
