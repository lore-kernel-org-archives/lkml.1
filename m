Return-Path: <linux-kernel-owner+w=401wt.eu-S1764051AbXGaPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764051AbXGaPSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760715AbXGaPSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:18:24 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34270 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761258AbXGaPSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:18:23 -0400
Message-ID: <46AF522B.3000606@gmail.com>
Date: Tue, 31 Jul 2007 17:15:55 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: jack@hawkeye.stone.uk.eu.org
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [Patch 02/16] Remove unnecessary kmalloc casts from the mips
 arch.
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125438.662563000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125438.662563000@hawkeye.stone.uk.eu.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2007 02:53 PM, jack@hawkeye.stone.uk.eu.org wrote:

> -	desc_base = (u32)kmalloc(entries * sizeof(au1x_ddma_desc_t),
> +	desc_base = kmalloc(entries * sizeof(au1x_ddma_desc_t),

The unnessary bit in kmalloc casts is due to void pointers being assignment 
compatible to other pointer types but in these patches you are also removing 
casts to unsigned long's and they should stay.

I noticed the same in patch 2, 4, 6, 8, 9 and 11 (cursory glance...)

Rene.
