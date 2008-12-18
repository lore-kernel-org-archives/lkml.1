Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbYLRVd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbYLRVd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYLRVdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:33:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:21202 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYLRVdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:33:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=fJRoSIr+O5d7zrd2iNzYr/uIfuoDZqH4Wf5qi5qT/HnnUWZvf5JQdr4nL/Zct0Etde
         iWKK6U5aLP7s/BkAaFaOGAH6RVrtimZoN27a6DkKWm2BC+6IoU/i3qCfgFS9ib5RaCru
         MUa8SuR8UVW3MjdLhhRPmXe9FNNmaaSL5ASLs=
Message-ID: <494AC1AF.8030309@gmail.com>
Date: Thu, 18 Dec 2008 22:33:35 +0100
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sshd segmentation fault on ia64 on 28-rc7-mmotm-081203	-	bisected
References: <1228322600.6693.61.camel@lts-notebook>	 <1228940487.6139.68.camel@lts-notebook>  <494AAA5C.6060601@gmail.com> <1229630744.6667.3.camel@lts-notebook>
In-Reply-To: <1229630744.6667.3.camel@lts-notebook>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn wrote:
> On Thu, 2008-12-18 at 20:54 +0100, Franck Bui-Huu wrote:
>> Could you apply the following patch with the previous patch applied
>> and see if sshd still segfaults ?
>>
>> It basically reverts:
>>
>>    do_mpage_readpage-remove-first_logical_block-parameter-fix.patch
>>
>> Therefore I can see which part of the patch is broken.
> 
> Will do, but I won't get to this before our lab shuts down for the rest
> of the year.

Thanks !

> 
>> Also can you tell me what the block size used by the file system
>> hosting sshd ?
> 
> 4K block size and fragment size, ext3.  system page size is 16K [ia64].
> 

OK.

		Franck

