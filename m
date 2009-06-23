Return-Path: <linux-kernel-owner+w=401wt.eu-S1760338AbZFWQ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338AbZFWQ3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZFWQ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:29:14 -0400
Received: from mail.atmel.fr ([81.80.104.162]:49374 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbZFWQ3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:29:14 -0400
Message-ID: <4A4102C5.4060509@atmel.com>
Date: Tue, 23 Jun 2009 18:28:53 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Rob Emanuele <rob@emanuele.us>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 1/6] atmel-mci: Unified Atmel MCI drivers (AVR32 & AT91)
References: <1245200079-6323-1-git-send-email-rob@emanuele.us>	<4A38BDB8.5030804@atmel.com> <20090617120849.4b11386a@hskinnemoen-d830>
In-Reply-To: <20090617120849.4b11386a@hskinnemoen-d830>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen :
> Nicolas Ferre wrote:
>>> -#define ATMCI_DATA_ERROR_FLAGS	(MCI_DCRCE | MCI_DTOE | MCI_OVRE | MCI_UNRE)
>>> +#define ATMCI_DATA_ERROR_FLAGS	(MCI_RINDE | MCI_RDIRE | MCI_RCRCE  \
>>> +				 | MCI_RENDE | MCI_RTOE | MCI_DCRCE \
>>> +				 | MCI_DTOE | MCI_OVRE | MCI_UNRE)  
>> Haavard, is it ok to add those flags on an AVR32 platform for now ?
> 
> It probably doesn't hurt on AVR32. But I'm not a great fan since it
> seems like the wrong thing to do, and it may simply mask the real
> problem.

Agreed.

To move forward, I will submit a first patch series without those flags
added.

Best regards,
-- 
Nicolas Ferre

