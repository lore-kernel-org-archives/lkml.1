Return-Path: <linux-kernel-owner+w=401wt.eu-S1761087AbYGAUfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761087AbYGAUfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759669AbYGAUen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:34:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:58192 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444AbYGAUel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TTaCr4nqFM/+yXXhJRGMa6nwHa0D9LxetrUCxfqFTo2ZgceS7/eZ7OK+cjRWkzof7k
         /kalD+hWWR6ek/zp+O9/TmZ+Rt6d9FHhNvUN1vBkFAzZ3p5MpGsuvVc5arqNLG+9ofAX
         kKln4//hG3056w6VnS3Sn3RPdZBVEAjWzlz1o=
Message-ID: <86802c440807011334u735ab53ep14c1039795eba5ec@mail.gmail.com>
Date: Tue, 1 Jul 2008 13:34:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86: unifying the 32 and 64 bit machine check handlers
Cc: "Max Asbock" <masbock@linux.vnet.ibm.com>,
       "Andi Kleen" <andi@firstfloor.org>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080701200952.GB4896@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214930223.20425.48.camel@w-amax.beaverton.ibm.com>
	 <20080701200952.GB4896@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 1:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Max Asbock <masbock@linux.vnet.ibm.com> wrote:
>
>> Is anybody currently working on combining the machine check handlers
>> for 32-bit and 64-bit x86? If there is interest I could post some
>> rough patches to get this started.
>
> sure, please do! I'd suggest to work against tip/master:
>
>   http://people.redhat.com/mingo/tip.git/README
>
> as there's tons of x86 changes queued up already.
>
> (ideally we'd like to see mcelog to work on 32-bit as well.)

suggest for now on:
merge should be change xxx_32.c xxx_64.c step by step till them become
all the same. So we can track the change for every file for both arch

like io_apic_32.c/io_apic_64.c apic_32.c/apic_64.c, sort the functions
at first...

YH
