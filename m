Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbXHITch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbXHITch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762970AbXHITcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:32:13 -0400
Received: from emulex.emulex.com ([138.239.112.1]:59789 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762924AbXHITcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:32:10 -0400
Message-ID: <46BB6BB8.4000509@emulex.com>
Date: Thu, 09 Aug 2007 15:32:08 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Emulex FC HBA driver: fix overflow of statically allocated
 array
References: <200708092047.16101.jesper.juhl@gmail.com>
In-Reply-To: <200708092047.16101.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Aug 2007 19:32:06.0640 (UTC) FILETIME=[F882A700:01C7DABB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

-- james s

Jesper Juhl wrote:
> I propose this patch, that simply changes the 'hbqno > LPFC_MAX_HBQS' 
> into 'hbqno >= LPFC_MAX_HBQS' as a possible fix.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  drivers/scsi/lpfc/lpfc_sli.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

