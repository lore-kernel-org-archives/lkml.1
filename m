Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbXH2Nhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbXH2Nhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 09:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbXH2Nhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 09:37:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275AbXH2Nhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 09:37:36 -0400
Message-ID: <46D5767C.9050206@redhat.com>
Date: Wed, 29 Aug 2007 09:37:00 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey>            <20070827214333.GM3118@fieldses.org> <7788.1188328346@turing-police.cc.vt.edu>
In-Reply-To: <7788.1188328346@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 27 Aug 2007 17:43:33 EDT, "J. Bruce Fields" said:
>
>   
>> Looks like a reasonable idea to me, thanks!  Any objection to just
>> calling it "svc_printk" instead of "svc_printkerr"?
>>
>> I also wonder whether these shouldn't all be dprintk's instead of
>> printk's.  One misbehaving client could create a lot of noise in the
>> logs.
>>     
>
> I shouldn't have to rebuild my kernel with debugging enabled just to see
> who is throwing trash at my machine.  printk(KERN_INFO maybe and/or using
> a printk_ratelimit.
>   

There are a lot of ways to discover who is throwing trash
at your system other than the kernel printing messages.

Tools such as tcpdump and tethereal/wireshark make much better
tools for this purpose.

    Thanx...

       ps
