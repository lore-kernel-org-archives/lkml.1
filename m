Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbXEMMpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbXEMMpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbXEMMo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:44:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:4082 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbXEMMoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O1jbL3OPMjm1HLo2ft6W8DVTWC1aEKLd9j5jHFgmEhYTwuWAmuk2lZxlc8xq2XPuFscfV+529hnp/PQo7GzRxteIO13ZewvO4L/N7DEHhDucDvfkgn2JkUtEPv9/PDu9XxETUR62JVrjOezlRPAVA1gZBSSQTv3B55dT379QmbQ=
Message-ID: <5a4c581d0705130544u24eb2f77te2823dab382186cc@mail.gmail.com>
Date: Sun, 13 May 2007 14:44:53 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Ok, the merge window has closed, and 2.6.22-rc1 is out there.

[snip]

I took a more careful look than with recent -gitXX, and
 for reporting's sake here's a few MODPOST warnings:

  MODPOST vmlinux
WARNING: init/built-in.o - Section mismatch: reference to .init.text:
from .text between 'rest_init' (at offset 0xfd) and 'try_name'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:
from .text between 'kmem_cache_create' (at offset 0x196e4) and
'cache_reap'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:
from .text between 'kmem_cache_create' (at offset 0x19716) and
'cache_reap

Grepping in my recent kernel build logs, the rest_init one
 seems to be present since -git7 but wasn't in -git6.

Googling around seems that this has already been looked
 into in the 2.6.20-rc series, with patches that may or may
 not have made it into mainline.


I still have old .config files, so if there's anything useful I
 can do to provide more info, just holler.

ciao,

--alessandro

 "Did you get married but forgot to get divorced ?"

     (Danny and Dusty, 'The Good Old Days')
