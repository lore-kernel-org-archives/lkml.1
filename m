Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYGNJ3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYGNJ3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbYGNJ33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:29:29 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46508 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754511AbYGNJ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:29:28 -0400
Message-ID: <487B1C73.5000202@sgi.com>
Date: Mon, 14 Jul 2008 11:29:23 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh <jaswinder@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH] qla1280: use request_firmware
References: <1215770284.2733.10.camel@jaswinder.satnam>
In-Reply-To: <1215770284.2733.10.camel@jaswinder.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh wrote:
> this is a first draft; please be kind :)
> 
> Firmware blob is little endian looks like this...
> 	unsigned char  Version1
> 	unsigned char  Version2
> 	unsigned char  Version3
> 	unsigned char  Padding
> 	unsigned short start_address
> 	unsigned short data

Hello,

As the maintainer of this driver I am going to say that I think this is
a stupid change. Yes I know that politically there's a move to make
everything use request firmware. However for my boot device, this is
going to be a royal pain in the butt for developers who wish to boot
test kernels with a / sitting on a 1280.

IMHO this patch brings us nothing, but provides a lot of unnecessary
hassle for users.

Nacked-By: Jes Sorensen <jes@sgi.com>

Regards,
Jes
