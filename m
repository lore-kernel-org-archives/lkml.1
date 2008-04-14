Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbYDNNyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbYDNNyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYDNNy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:54:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:54440 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYDNNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VYKRbrf1Foq3PRiq+o6xvzirWsxl8qW25H4wdq2245Kvb6zht5suWkZYSKtWYMcAnpe0JwzOyc5ooHI3b6Rq5mmCMRpIVMWydudfT3hK0vcur5ajNQ7NR2Wa3vGT/QES8WEJ/mfz/1o1+nyEYzGj4nBmfSOnTZeg1PD9wX9FNLg=
Message-ID: <4803620C.6020905@gmail.com>
Date: Mon, 14 Apr 2008 15:54:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com>	<12053582231281-git-send-email-yorksun@freescale.com>	<47D8572C.8090501@gmail.com>	<47FFDBFF.1030809@gmail.com> <20080411221817.0b1eb414.akpm@linux-foundation.org> <48035E93.6070300@freescale.com> <48035F98.1020404@gmail.com> <48036001.10905@freescale.com>
In-Reply-To: <48036001.10905@freescale.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2008 03:45 PM, Timur Tabi wrote:
> Jiri Slaby wrote:
> 
>> See
>> http://lkml.org/lkml/2008/3/12/375
> 
> That email is dated 3/12 and those comments are about v1 of the patch.  The most
> recent posted version is v5 and it addresses all these issues.  See
> http://lkml.org/lkml/2008/4/1/346

Ok, how is the sleep-inside-spinlock in fsl_diu_open resolved? rh_alloc might 
sleep if I still see correctly, do I?
