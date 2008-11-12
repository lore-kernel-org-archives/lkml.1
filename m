Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYKLMy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYKLMy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYKLMyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:54:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45526 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYKLMyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:54:17 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Frysinger <vapier@gentoo.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org, Holger Waechtler <holger@convergence.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ttusb-budget: make it depend on PCI
From: Andi Kleen <andi@firstfloor.org>
References: <1226491218-9281-1-git-send-email-vapier@gentoo.org>
	<200811121336.00521.arnd@arndb.de>
Date: Wed, 12 Nov 2008 14:11:45 +0100
In-Reply-To: <200811121336.00521.arnd@arndb.de> (Arnd Bergmann's message of "Wed, 12 Nov 2008 13:35:59 +0100")
Message-ID: <874p2ddr72.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Wednesday 12 November 2008, Mike Frysinger wrote:
>> From: 
>> Mike Frysinger <vapier@gentoo.org>
>>   To: 
>> v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org, Holger Waechtler <holger@convergence.de>
>>   CC: 
>> Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org
>>   Date: 
>> Today 13:00:18
>>    
>> Since dvb-ttusb-budget.c relies on pci_alloc_consistent and
>> pci_free_consistent, make it depend on PCI in Kconfig.
>> 
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> Shouldn't you just convert it (trivially) to dma_alloc_coherent and
> dma_alloc_coherent?

Unless it really needs to use the 16MB DMA zone (which I doubt
especially for USB devices) then it should not call either with a NULL
device argument.

-Andi

-- 
ak@linux.intel.com
