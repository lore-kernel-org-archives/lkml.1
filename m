Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXCUMJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXCUMJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbXCUMJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:09:05 -0400
Received: from neon.samage.net ([83.149.67.130]:37299 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbXCUMJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:09:02 -0400
Message-ID: <4040.81.207.0.53.1174478934.squirrel@secure.samage.net>
In-Reply-To: <000e01c76b99$769cbbe0$0864a8c0@scs1>
References: <45FEB8B7.7020200@sciensis.com>
    <20070320004001.GA11601@electric-eye.fr.zoreil.com>
    <000601c76af9$a0ce3ce0$0864a8c0@scs1>
    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>
    <000e01c76b99$769cbbe0$0864a8c0@scs1>
Date: Wed, 21 Mar 2007 13:08:54 +0100 (CET)
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
X-Spam-Score: -1.3
X-Scan-Signature: 2ecd0b53b7de9511489f92806276a3d7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 21, 2007 10:15, Tasos Parisinos wrote:
>> Assuming you have a secure kernel binary that is tamper proof, why do you need
>> slow and complex asymmetric encryption again? If you can write protect the kernel,
>> you can also read protect it (or let the boot loader pass the key to the kernel).
>> So what stops you from using a simple symmetric key cipher for signing?
>
> In symmetric cryptography you would give away your key if one could read the kernel binary
> while in assymetric one can only get the public key

If you can't read protect your kernel, you can't write protect it either. Of course the
symmetric key would be per kernel, not a single global one.

> Protecting a TripleDES key in high security standards is not as simple as making the kernel
> read protected, you need a whole lot and that also means hardware (cryptomemories e.t.c)
> So you forget about all this overhead when you use assymetric

You need to protect your kernel binary already, adding a key to that doesn't increase the
complexity or safety requirements, so all that hardware safety is already in place.
(And I'd use AES instead of TripleDES.)

> Also this is the way this is done in all implementations ranging from Linux platforms (see
> DigSig@sourceforge for an example, or in
> Debian, Fedora) and in Microsoft platforms as far as i know

Nothing stops you from signing the binaries with an asymmetric key. After checking that
signature the user can sign the binary with his private symmetric key and upload it to
the device.

Greetings,

Indan


