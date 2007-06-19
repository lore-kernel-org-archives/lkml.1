Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbXFSOIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbXFSOIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXFSOIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:08:22 -0400
Received: from h155.mvista.com ([63.81.120.155]:37645 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267AbXFSOIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:08:21 -0400
Message-ID: <4677E3BC.3040307@ru.mvista.com>
Date: Tue, 19 Jun 2007 18:10:04 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linas Vepstas <linas@austin.ibm.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com>	<20070618212704.394912b8@the-village.bc.nu>	<20070618204601.GF5836@austin.ibm.com> <20070618220441.3a3af8ca@the-village.bc.nu>
In-Reply-To: <20070618220441.3a3af8ca@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:
>>I can prepare a patch, but only with a lot of guidance. I can test 
>>& debug, I'm highly motivated just right now ... 

> If you've got a nice repeatable problem please try using the libata
> driver. That handles the error paths differently and doesn't try a FIFO
> drain which might matter in this case I guess.

    FIFO drain for DMA commands?

MBR, Sergei
