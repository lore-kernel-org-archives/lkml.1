Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbXCTPoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbXCTPoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbXCTPoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:44:05 -0400
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:33178 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbXCTPoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:44:03 -0400
Message-ID: <46000138.20007@grupopie.com>
Date: Tue, 20 Mar 2007 15:43:52 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Tasos Parisinos <t.parisinos@sciensis.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version
 2.6.20.1)
References: <45FEB8B7.7020200@sciensis.com> <20070319225858.GK10459@waste.org>
In-Reply-To: <20070319225858.GK10459@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> [...]
>> +    /* Allocate space for the mpi and its data */
>> +    s = (size / 4) + ((size % 4)? 1: 0);
> 
> Uhhh.. (size + 1) / 4?

You mean "(size + 3) / 4", no?

Overall, I agree with your comments: this file looks like it needs a lot 
more CodingStyle ;)

Redefining standard kernel interfaces (error numbers, memory allocation, 
printk, etc.) is not the right way to get code merged.

-- 
Paulo Marques - www.grupopie.com

"For every problem there is one solution which is simple, neat, and wrong."
H. L. Mencken
