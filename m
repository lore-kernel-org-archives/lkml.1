Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbXGMKKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbXGMKKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 06:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXGMKKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 06:10:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:54534 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbXGMKKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 06:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=lR6D4lslGfVD6iXRJISbSq2TV4st8ju421jHD+WZntauN+wVqRlUap0HfYjK8G/Vnpwcp/dQfx/kXN5+ooCoFCBhJR1NWKOummiUSBKpU4B0/XBGObOkdju1XyJnluKtnag+4KZ1Y26RJNWR9UdkKzX+ieir3d7/EHwvi83p15M=
Message-ID: <46974F76.9070909@googlemail.com>
Date: Fri, 13 Jul 2007 12:09:58 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: On current git head webservers stopped working
References: <469745A8.6010005@googlemail.com> <20070713093459.GB5328@kernel.dk> <46974ABF.9030408@googlemail.com> <20070713100057.GD5328@kernel.dk>
In-Reply-To: <20070713100057.GD5328@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Jul 13 2007, Gabriel C wrote:
>   
>> Jens Axboe wrote:
>>     
>>> On Fri, Jul 13 2007, Gabriel C wrote:
>>>   
>>>       
>>>> Hello ,
>>>>
>>>> While doing some tests with 2.6.22-git2 ( at the time head
>>>> 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4 ) all my webservers stopped
>>>> working.
>>>> I can't get any file using wget or whatever else , everything hangs
>>>> after 1% forever.
>>>>
>>>> I bisected this and here the result:
>>>>
>>>> 534f2aaa6ab07cd71164180bc958a7dcde41db11 is first bad commit
>>>> commit 534f2aaa6ab07cd71164180bc958a7dcde41db11
>>>> Author: Jens Axboe <jens.axboe@oracle.com>
>>>> Date:   Fri Jun 1 14:52:37 2007 +0200
>>>>
>>>>     sys_sendfile: switch to using ->splice_read, if available
>>>>
>>>>     This patch makes sendfile prefer to use ->splice_read(), if it's
>>>>     available in the file_operations structure.
>>>>
>>>>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>>>>
>>>> :040000 040000 b19013793692eee0f632b3703dca0bd40cea753f
>>>> ed50576c0d3f0d3ce9f1a2ac9336d1164b45f63f M      fs
>>>>     
>>>>         
>>> Does this work?
>>>   
>>>       
>> Yes , it does. Thx :)
>>     
>
> Great, I'll polish it a bit and get it upstream asap. Thanks for the
> report and quick test feedback!
>
>   

You are welcome :)

If you want me to test the final version of this patch before you push
it upstream just ping me.



