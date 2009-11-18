Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZKRSqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZKRSqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZKRSqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:46:45 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:63486 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753872AbZKRSqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:46:44 -0500
Message-ID: <4B04413D.30302@ru.mvista.com>
Date: Wed, 18 Nov 2009 21:47:25 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
References: <20091117144450.15430.83450.stgit@localhost.localdomain>	<20091117145137.15430.11229.stgit@localhost.localdomain>	<200911181919.19127.bzolnier@gmail.com> <20091118184125.623e063d@lxorguk.ukuu.org.uk>
In-Reply-To: <20091118184125.623e063d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

  >>Having separate drivers wasn't the best decisions from the maintainability
>>point-of-view.   It added needless complexity (different chips share the same

> It was most definitely a good decision, having maintained both sets of

    Separating HPT36x was grounded enough decision but I can't say the same 
of the separation of HPT3xxN.

> drivers at different times. It also makes it possible to do things the
> way highpoint does

    Oh, don't remind me of that stupid code mostly not worth copying from...

>>PCI IDs which make detection across multiple drivers extremely painful) and
>>confusion (i.e. would you have guessed that HPT302 is supported by pata_hpt37x
>>while HPT302N by pata_hpt3x2n?).

    How about HPT371N? ;-)

WBR, Sergei
