Return-Path: <linux-kernel-owner+w=401wt.eu-S1765187AbZDCLqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765187AbZDCLqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932252AbZDCLqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:46:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45129 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbZDCLq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:46:28 -0400
Message-ID: <49D5F72E.2060804@redhat.com>
Date: Fri, 03 Apr 2009 14:46:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gerd Hoffmann <kraxel@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, ghaskins@novell.com,
       anthony@codemonkey.ws, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D5EBE1.8030200@redhat.com> <20090403111854.GA11935@one.firstfloor.org>
In-Reply-To: <20090403111854.GA11935@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Check shared ring status when stuffing a request.  If there are requests
>>     
>
> That means you're bouncing cache lines all the time. Probably not a big
> issue on single socket but could be on larger systems.
>   

That's why I'd like requests to be handled on the vcpu thread rather 
than an auxiliary thread.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

