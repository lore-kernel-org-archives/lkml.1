Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYB0La1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYB0La1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYB0LaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:30:17 -0500
Received: from stinky.trash.net ([213.144.137.162]:50257 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYB0LaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:30:16 -0500
Message-ID: <47C549B0.4020000@trash.net>
Date: Wed, 27 Feb 2008 12:29:52 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Martin Michlmayr <tbm@cyrius.com>, linux-kernel@vger.kernel.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: 2.6.25-rc3: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
References: <20080226122100.GB22699@deprecation.cyrius.com> <alpine.DEB.1.00.0802261945370.22324@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0802261945370.22324@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 26 Feb 2008, Martin Michlmayr wrote:
>
>   
>> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
>>     
>
> crypto: use do_div() when registering the rng
>
> Use do_div() instead of the divide operator.
>
>   

This is similar to my patch, which didn't fix the problem. Adrian
already fixed it.

