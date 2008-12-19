Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYLSLew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYLSLew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYLSLeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:34:44 -0500
Received: from h155.mvista.com ([63.81.120.155]:51305 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751043AbYLSLen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:34:43 -0500
Message-ID: <494B86CD.4060305@ru.mvista.com>
Date: Fri, 19 Dec 2008 14:34:37 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O support
 properly
References: <494A5BBF.8000807@inf.tu-dresden.de>	<494A837A.50801@garzik.org>	<494A8768.4080100@ru.mvista.com>	<200812182142.16533.bzolnier@gmail.com> <20081218224010.45e3ce55@lxorguk.ukuu.org.uk> <494B8617.3020808@ru.mvista.com>
In-Reply-To: <494B8617.3020808@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I just wrote:

>> I remain unconvinced we should be looking at it anywhere except specific
>> pure ISA cycle pass through hardware and thus it belongs as a helper for
>>   
>
>   I'm still not getting how drive can support or not support "DWORD 
> I/O" -- you certainly can't have 32-bit I/O cycle on ISA (only on 
> EISA) and you certainly cannot translate 32-bit cycle to the ATA bus. 
> I remember I had some hypotheses before but they turned out to be 
> inconsistent.

   If only two back-to-back I/O cycles weren't providing enough recovery 
time...

MBR, Sergei


