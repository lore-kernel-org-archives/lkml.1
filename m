Return-Path: <linux-kernel-owner+w=401wt.eu-S1751133AbXCUJir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbXCUJir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 05:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbXCUJiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 05:38:46 -0400
Received: from mailout15.yourhostingaccount.com ([65.254.253.120]:47168 "EHLO
	mailout15.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbXCUJiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 05:38:46 -0400
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 05:38:45 EDT
Message-ID: <000e01c76b99$769cbbe0$0864a8c0@scs1>
From: "Tasos Parisinos" <t.parisinos@sciensis.com>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Francois Romieu" <romieu@fr.zoreil.com>, <herbert@gondor.apana.org.au>,
       <linux-kernel@vger.kernel.org>
References: <45FEB8B7.7020200@sciensis.com>    <20070320004001.GA11601@electric-eye.fr.zoreil.com>    <000601c76af9$a0ce3ce0$0864a8c0@scs1> <4734.81.207.0.53.1174427010.squirrel@secure.samage.net>
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel      version 2.6.20.1)
Date: Wed, 21 Mar 2007 11:15:19 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-EN-UserInfo: 6b5ac0c6b5a8f649d336ffa6ba3f3bc4:297516c839f78035fb456ced5af6b435
X-EN-AuthUser: tparisinos@sciensis.com
X-EN-OrigIP: 88.218.52.108
X-EN-OrigHost: dsl-88-218-52-108.customers.vivodi.gr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Assuming you have a secure kernel binary that is tamper proof, why do you need
> slow and complex asymmetric encryption again? If you can write protect the kernel,
> you can also read protect it (or let the boot loader pass the key to the kernel).
> So what stops you from using a simple symmetric key cipher for signing?

In symmetric cryptography you would give away your key if one could read the kernel binary
while in assymetric one can only get the public key

Protecting a TripleDES key in high security standards is not as simple as making the kernel read protected, you need a whole lot and 
that also means hardware (cryptomemories e.t.c)
So you forget about all this overhead when you use assymetric

Also this is the way this is done in all implementations ranging from Linux platforms (see DigSig@sourceforge for an example, or in 
Debian, Fedora) and in Microsoft platforms as far as i know


