Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbYEWUbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbYEWUbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYEWUbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:31:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35750 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbYEWUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:31:09 -0400
Message-ID: <48372989.3000700@garzik.org>
Date: Fri, 23 May 2008 16:31:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andras Mantia <amantia@kde.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: libata (pata_via) timeouts causing unusable device: the famous
 DRDY issue?
References: <200805232201.51701.amantia@kde.org>
In-Reply-To: <200805232201.51701.amantia@kde.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andras Mantia wrote:
> Hi,
> 
>  since my upgrade to openSUSE 11.0, which comes with 2.6.25.4, soon 
> after I start using my DVD player, I get the following in the log:
> 
> May 23 21:34:04 stein klogd: ata1.00: exception Emask 0x0 SAct 0x0 SErr 
> 0x0 action 0x2 frozen                                                  
> May 23 21:34:04 stein klogd: ata1.00: cmd 
> a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2048 in                                                
> May 23 21:34:04 stein klogd:          cdb 28 00 00 00 01 b3 00 00  01 00 
> 00 00 00 00 00 00                                                     
> May 23 21:34:04 stein klogd:          res 
> 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)                                              
> May 23 21:34:04 stein klogd: ata1.00: status: { DRDY }  

DRDY == device ready, and it occurs billions of times per day during 
normal use.

There is no "famous DRDY issue", you are simply seeing timeouts.

Have you tried all of: pci=nomsi, acpi=off, or noapic?

	Jeff


