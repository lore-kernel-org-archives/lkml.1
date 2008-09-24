Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYIXL7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYIXL7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYIXL71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:59:27 -0400
Received: from mail.atmel.fr ([81.80.104.162]:55983 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYIXL70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:59:26 -0400
Message-ID: <48DA2B94.3020804@atmel.com>
Date: Wed, 24 Sep 2008 13:59:16 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: maciej.sosnowski@intel.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>
CC: dan.j.williams@intel.com, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: dmaengine: DMA_CTRL_ACK flag signification
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am in the process of writing a driver for an on-chip Atmel DMA engine.

I am a little confused about the use of the flag DMA_CTRL_ACK : It seems 
that it is set in most of the descriptors in use except the first or 
last of a descriptor chain. So, I cannot find where this flag is cleared.
In short, I do not see what it is used for : how must I take it into 
account in my driver (in device_prep_dma_memcpy() for instance) ?

Can you enlighten me ?

Regards,
-- 
Nicolas Ferre

