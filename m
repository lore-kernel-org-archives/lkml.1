Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbXCUMfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbXCUMfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXCUMfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:35:00 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:1892 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbXCUMe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:34:59 -0400
Message-ID: <4601265F.4030907@sciensis.com>
Date: Wed, 21 Mar 2007 14:34:39 +0200
From: Tasos Parisinos <t.parisinos@sciensis.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
Cc: Francois Romieu <romieu@fr.zoreil.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel  
         version 2.6.20.1)
References: <45FEB8B7.7020200@sciensis.com>    <20070320004001.GA11601@electric-eye.fr.zoreil.com>    <000601c76af9$a0ce3ce0$0864a8c0@scs1>    <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>    <000e01c76b99$769cbbe0$0864a8c0@scs1> <4040.81.207.0.53.1174478934.squirrel@secure.samage.net>
In-Reply-To: <4040.81.207.0.53.1174478934.squirrel@secure.samage.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
>> Protecting a TripleDES key in high security standards is not as simple as making the kernel
>> read protected, you need a whole lot and that also means hardware (cryptomemories e.t.c)
>> So you forget about all this overhead when you use assymetric
>>     
>
> You need to protect your kernel binary already, adding a key to that doesn't increase the
> complexity or safety requirements, so all that hardware safety is already in place.
> (And I'd use AES instead of TripleDES.)
>
>   
Well, lets assume you have a trapped casing that prevents a flash chip 
(which holds
the kernel) from being tamperred. Then you have write protection of the 
bzimage

When this thing will run, and it will need to check an executable using 
AES for example
(which is a lot better than TripleDes, i agree) then the key will be for 
a time window
onto buses and memory. Then it can be probed and retrieved by someone.

Then you need cryptomemory

While with asymmetric you don't. There are no high-risk data anywhere, 
only a public
key

Of course if you have other data that need to be secured, and you 
already run
on a trusted platform, including all these crypto hardware modules, then 
you can use
a symmetric scheme

Tasos Parisinos
-
