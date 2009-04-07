Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZDGJPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZDGJPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZDGJPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:15:17 -0400
Received: from h155.mvista.com ([63.81.120.155]:32226 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753415AbZDGJPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:15:15 -0400
Message-ID: <49DB199C.3040305@ru.mvista.com>
Date: Tue, 07 Apr 2009 13:15:08 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2 resend] libata-sff: avoid byte swapping in ata_sff_data_xfer()
References: <200902152230.38271.sshtylyov@ru.mvista.com>
In-Reply-To: <200902152230.38271.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

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

   Jeff, have you forgotten about this one?

MBR, Sergei


