Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbXCTVnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbXCTVnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXCTVnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:43:40 -0400
Received: from neon.samage.net ([83.149.67.130]:58077 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbXCTVnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:43:39 -0400
Message-ID: <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>
In-Reply-To: <000601c76af9$a0ce3ce0$0864a8c0@scs1>
References: <45FEB8B7.7020200@sciensis.com>
    <20070320004001.GA11601@electric-eye.fr.zoreil.com>
    <000601c76af9$a0ce3ce0$0864a8c0@scs1>
Date: Tue, 20 Mar 2007 22:43:30 +0100 (CET)
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel 
     version 2.6.20.1)
From: "Indan Zupancic" <indan@nul.nu>
To: "Tasos Parisinos" <t.parisinos@sciensis.com>
Cc: "Francois Romieu" <romieu@fr.zoreil.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 4052b6d1c9976086d5ab5ce040fcf5b8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, March 20, 2007 15:11, Tasos Parisinos wrote:
> Francois Romieu wrote:
>
>> RSA is slow. syscalls are fast.
>>
>> Which part of the kernel is supposed to benefit from this code ?
>
> The main purpose behind the development of this module was to create an in-kernel
> system of signed modules. The scenario applies most in embedded systems that are running linux
> where the kernel is physically secure but its filesystem is not, so one may tamper executable
> code.

I'll summarize/rephrase what I've already said in the thread James Morris linked to:

You need a way to protect your kernel binary, or else this whole thing becomes a joke.
(Modify kernel, reboot...)

Assuming you have a secure kernel binary that is tamper proof, why do you need
slow and complex asymmetric encryption again? If you can write protect the kernel,
you can also read protect it (or let the boot loader pass the key to the kernel).
So what stops you from using a simple symmetric key cipher for signing?

Regards,

Indan


