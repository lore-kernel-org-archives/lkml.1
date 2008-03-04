Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbYCDKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbYCDKkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbYCDKkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:40:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:1080 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYCDKkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=w/B+uVWLcfY1sK3J1dVbWax7ZTkcm3d+WLjxN3CbIxnoprFd0z09TEqouLeTQ6r6CvmeCnrSnsc6pau6VvubB5/PBHu8V7qrG+wtGK1jmf2V+SSQBDN9Mt54V1mzqnYmODNgi4fYbu7gD/zp//r5lCjMPLx+eDyxVCQ+QCwjK1w=
Message-ID: <47CD2753.5050905@gmail.com>
Date: Tue, 04 Mar 2008 11:41:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jan Sonnek <xsonnek@fi.muni.cz>
Subject: Re: [2.6.25-rc2-mm1] Oops in __kmalloc
References: <47C42DDF.3060506@gmail.com> <20080226100913.9412b41c.akpm@linux-foundation.org>
In-Reply-To: <20080226100913.9412b41c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Tue, 26 Feb 2008 16:18:55 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Hi,
>>
>> while booting up a notebook on 32 bit, this oopses appeared on the console
>> after ext3 fsck:
>> http://www.fi.muni.cz/~xslaby/sklad/mem_oops/
>>
>> It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
>> issue (unlikely, 2.6.24.2 seems to be OK)?
> 
> I don't recall seeing a similar report and yes, it'll be a kernel bug.
> 
> We've fixed a few things and it could be that this will just go away in
> next -mm.  If it doesn't, a bisection search would be good, thanks.

Well, next -mm is out. Could you test, Jan? [our -mm git is up-to-date]
