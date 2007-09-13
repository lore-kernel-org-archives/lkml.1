Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbXIMV5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbXIMV5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbXIMV4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:56:54 -0400
Received: from gw.goop.org ([64.81.55.164]:46640 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbXIMV4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:56:54 -0400
Message-ID: <46E9B22B.1000002@goop.org>
Date: Thu, 13 Sep 2007 14:56:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] Add ELF note with Linux version
References: <20070904150018.GA4357@suse.de>	<46DFD825.2020109@goop.org> <20070913144228.2efcd5d9.akpm@linux-foundation.org>
In-Reply-To: <20070913144228.2efcd5d9.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 06 Sep 2007 11:36:21 +0100
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Bernhard Walle wrote:
>>     
>>> This patch adds version information to the ELF kernel file. Together
>>> with the bzImage version information, this allows distributions to
>>> identify the kernel version based on the file name.
>>>   
>>>       
>> Seems reasonable to me, but I think the macro could be just called
>> "ELFNOTE".
>>
>>     
>
> You removed Bernhard from the cc list.
>   

Didn't mean to... Oh, he has a "mail-followup-to" header which doesn't
include himself...

> I'd like to know a little bit more about why this is needed, how it will be
> used, etc.  And given that this feature is intended to improve life for
> distributors, it would be nice to get some feedback from the appropriate
> persons.

Hm, yes.  ELF notes don't appear in the bzImage, since it isn't an ELF
file, so perhaps this doesn't satisfy the requirement.  It would help to
have more detail.

    J
