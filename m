Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZDTXmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZDTXmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZDTXmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:42:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:2649 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZDTXme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:42:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Bm6b0nr8WzMF6YOFI1s8QkfMQnk7NiZM/7V+yrHEywcamWVhJsMaQPPtXNCr9B2rhp
         9eCo32uNS4HLQ1tPZ20JbZbuvkc7TI76v/G144v2N5hq5sw3BlMNiA/396oqCQOiMliU
         TFdHKlKBN2VNi8LwLRHSZvHCnaEI16TqFDC6Y=
Message-ID: <49ED0865.9030603@gmail.com>
Date: Mon, 20 Apr 2009 17:42:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: sdhci-devel@lists.ossman.eu, pierre@ossman.eu,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: SDHCI driver runnining in aspire one, allows to write to R/O
 SD   cards
References: <1240219764.13640.5.camel@maxim-laptop>
In-Reply-To: <1240219764.13640.5.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> Hi,
> 
> I am an owner of aspire one, and it has a card reader.
> when I take a sd card, and pull down the protection tab, it still allows
> to write to the card (I tested with my main notebook that indeed, it did
> write there).
> 
> My main notebook, acer aspire 5720, doesn't have this problem.
> Kernel version in use is 2.6.28 vanilla, but this did happen in former
> version as well.
> 
> 
> Attached lspci, on acer one.

Do you know if it worked in any kernel version or OS? It's known that 
some SD card readers are too cheap to actually implement the 
write-protect detection.
