Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbZDHGeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbZDHGeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbZDHGdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:33:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54838 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760855AbZDHGdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:33:46 -0400
Message-ID: <49DC4545.5020702@pobox.com>
Date: Wed, 08 Apr 2009 02:33:41 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2 resend] libata-sff: avoid byte swapping in ata_sff_data_xfer()
References: <200902152230.38271.sshtylyov@ru.mvista.com>
In-Reply-To: <200902152230.38271.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Handling of the trailing byte in ata_sff_data_xfer() is suboptimal bacause:
> 
> - it always initializes the padding buffer to 0 which is not really needed in
>   both the read and write cases;
> 
> - it has to use memcpy() to transfer a single byte from/to the padding buffer;
> 
> - it uses io{read|write}16() accessors which swap bytes on the big endian CPUs
>   and so have to additionally convert the data from/to the little endian format
>   instead of using io{read|write}16_rep() accessors which are not supposed to
>   change the byte ordering.
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied


