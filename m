Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbZHVFnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbZHVFnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 01:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932666AbZHVFnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 01:43:39 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:34987 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbZHVFnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 01:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mTXbROg7seoQcYUxvsE1Z3x0x22WBPyuVcbkUEVvC468SJGGfDPCe8ESXG1Dz9p05k
         ZrMpBkVeatvWLemHexB8FYRTCymayxbutJMNqup5sAdmcEEIBsP0OXfRYTSjTcYlpLn3
         qouD67C6U2c3N1bwCj5WcARvnZ08oSUnv6dUs=
Message-ID: <4A8F8586.5050300@gmail.com>
Date: Fri, 21 Aug 2009 23:43:34 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and
 earlier.
References: <200908211814.56800.volkerarmin@googlemail.com>
In-Reply-To: <200908211814.56800.volkerarmin@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 10:14 AM, Volker Armin Hemmann wrote:
> Hi,
>
> I have an amd64 system with 8GB ram. Of these only 3.1GB are currently covered
> with mtrr:
> cat /proc/mtrr
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back
>
> This is with a Phenom II X4. Mobo is an Asrock A770Crossfire with AMD 770
> chipset. Ram is 1066 ddr2 running at 800.
>
> Before that I had a X2 6000 where I had one more mtrr, covering additional
> 256mb with 6gb ram total.
>
> When I use the opensource driver, I get a 'mtrr disabled' message when X
> starts, nothing like that with fglrx. The results are the same.
>
> Is there anything that I can do about it? I already played with mtrr cleanup
> options - without any results.

I seem to recall hearing that on some newer AMD CPUs the memory above 
4GB is either hardcoded to cacheable or set that way via some other 
mechanism such that MTRRs aren't needed for it. Maybe someone else can 
provide more details.
