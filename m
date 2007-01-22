Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbXAVU25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbXAVU25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbXAVU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:28:57 -0500
Received: from h155.mvista.com ([63.81.120.155]:36756 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751980AbXAVU24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:28:56 -0500
Message-ID: <45B51E83.1010904@ru.mvista.com>
Date: Mon, 22 Jan 2007 23:28:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	<20070119003226.14846.87052.sendpatchset@localhost.localdomain>	<45B4FFBD.40507@ru.mvista.com> <20070122184620.1c8b87ac@localhost.localdomain>
In-Reply-To: <20070122184620.1c8b87ac@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan wrote:

>>    Ugh, I'm not seeing any *actual* support for MW/SW DMA in this driver... 

> Thats long been broken. Should be correct in the libata driver

    Here's a surprise for you. pata_cmd64x copied the SW/MW DMA setup code 
from the IDE driver.  No way it could be working.  You may check against the 
PC64x datasheets (if you have them -- if you don't I think I may share) and 
see for yourself -- it's abolutely idiotic.

> Alan

WBR, Sergei
