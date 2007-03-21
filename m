Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbXCUMgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbXCUMgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbXCUMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:36:46 -0400
Received: from neon.samage.net ([83.149.67.130]:56112 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbXCUMgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:36:45 -0400
Message-ID: <3118.81.207.0.53.1174480598.squirrel@secure.samage.net>
In-Reply-To: <000e01c76b99$769cbbe0$0864a8c0@scs1>
References: <45FEB8B7.7020200@sciensis.com>
    <20070320004001.GA11601@electric-eye.fr.zoreil.com>
    <000601c76af9$a0ce3ce0$0864a8c0@scs1>
    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>
    <000e01c76b99$769cbbe0$0864a8c0@scs1>
Date: Wed, 21 Mar 2007 13:36:38 +0100 (CET)
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
X-Scan-Signature: a07cf4f22b7e0347d98fbeb4081a69be
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 21, 2007 10:15, Tasos Parisinos wrote:
> Protecting a TripleDES key in high security standards is not as
> simple as making the kernel read
> protected, you need a whole lot and
> that also means hardware (cryptomemories e.t.c)
> So you forget about all this overhead when you use assymetric

Ah, you're talking about fishing the key out of RAM here, right?
My point stays the same for that: If you can't read protect the
kernel RAM, small chance you can write protect it. And then they
can just bypass all signature checking you put in it anyway.

Greetings,

Indan


