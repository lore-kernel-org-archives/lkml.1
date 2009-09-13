Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZIMAcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZIMAcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 20:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZIMAb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 20:31:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47463 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZIMAb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 20:31:57 -0400
Message-ID: <4AAC3D78.7070806@pobox.com>
Date: Sat, 12 Sep 2009 20:31:52 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Jung-Ik (John) Lee" <jilee@google.com>
CC: Robert Hancock <hancockrwd@gmail.com>, Daniel Walker <dwalker@fifo99.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@google.com>,
       Gwendal Grignou <gwendal@google.com>, Eric Uhrhane <ericu@google.com>
Subject: Re: [PATCH] libata: Add pata_atp867x driver for Artop/Acard ATP867X
 	controllers
References: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com> 	<1252721641.28368.34.camel@desktop> <8b5805ff0909120359g2faf661br463b19518d935110@mail.gmail.com> 	<4AABD122.2000400@gmail.com> <8b5805ff0909121717w1516c273k2a568779b9c31662@mail.gmail.com> <8b5805ff0909121726g2f1a78c1o1ff7289e059eabe5@mail.gmail.com>
In-Reply-To: <8b5805ff0909121726g2f1a78c1o1ff7289e059eabe5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2009 08:26 PM, Jung-Ik (John) Lee wrote:
> From: John(Jung-Ik) Lee<jilee@google.com>
>
> This is a new pata driver for ARTOP 867X 64bit 4-channel UDMA133 ATA ctrls.
> Based on the Atp867 data sheet rev 1.2, Acard, and in part on early ide codes
> from Eric Uhrhane<ericu@google.com>.
>
> Signed-off-by: John(Jung-Ik) Lee<jilee@google.com>
> Reviewed-by:  Grant Grundler<grundler@google.com>
> Reviewed-by:  Gwendal Gringo<gwendal@google.com>
> ---
>
>   drivers/ata/Kconfig        |    9 +
>   drivers/ata/Makefile       |    1 +
>   drivers/ata/pata_atp867x.c |  578 ++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/pci_ids.h    |    2 +
>   4 files changed, 590 insertions(+), 0 deletions(-)

What changed in this patch, versus previous patches?

(that's a question, and also an indication of what needs to be 
explicitly stated in your email body, immediately following the "---" 
separator, for each patch revision)

Since the merge window is open, I will likely send this driver upstream 
as soon as feedback level approaches zero.

	Jeff



