Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbXJAJKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbXJAJKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXJAJKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:10:22 -0400
Received: from n7.bullet.mud.yahoo.com ([216.252.100.58]:34402 "HELO
	n7.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750912AbXJAJKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:10:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 308028.42910.bm@omp101.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=lUVapiL1EKJnQozhcUV8Go1a4BzqxjAdmJst7d0WMrogji9z0oVMERAXx+UfrPvswLbvpLf0XOZ+w1tVryHaTjv8c3sM6Zv/onTj/4igs0/ESJNfAOBRkcDZNRbsLhMZpz2WEjS1p0SEIvzxLxc4AnKs0gM6tTACvHc1QatGQFg=;
X-YMail-OSG: OvqjJSIVM1k_lSVRAynBOP_A43iN1H_VzB1zKuh_Bsd6U_rNdd8hCJ7YDDBBBSvEl6mpv3CG8S3CblaZVZjTJfBgdqq9I4fWKvzRWeEnf3bX9SghKLoaIpCUk2P1HQ--
Date: Mon, 1 Oct 2007 10:04:32 +0100 (BST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: linux cache routines for Write-back cache policy on  MIPS24KE
To: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <119374.35234.qm@web8401.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have ported Linux-2.6.18 kernel on MIPS24KE
processor. I am using write back cache policy.

Could you please guide me under what cases the below
cache API's are being used:
- dma_cache_wback_inv() : Could you explain  what
exactly this function does
- dma_cache_wback() : This function write back the
cache data to memory
- dma_cache_inv  : This function invalidate the cache
tags. so subsequent access will fetch from memory.

Once I looked the above function definitions in
linux-2.6.18/arch/mips/mm/c-r4k.c.
All these function's implemetation are same except
bc_wbak_inv() is called in both dma_cache_wback-inv()
and dma_cache_wback(), where as bc_inv() is called in
case of dma_cache_inv.

Also, bc_inv()/bc_wbak_inv are define as null
implementation for R4000.
That means all three functions are doing same
functionality in case of R4000.

What are the difference between these three functions.
Under what cases these functions are used. 

Please guide me if you have any links which will
explain these API's.
Thanks in advance.

Regards,
Veerasena.


      Forgot the famous last words? Access your message archive online at http://in.messenger.yahoo.com/webmessengerpromo.php

