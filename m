Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbXGWM3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbXGWM3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXGWM31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:29:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:34255 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbXGWM31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:29:27 -0400
Message-ID: <46A49F30.5010206@qumranet.com>
Date: Mon, 23 Jul 2007 15:29:36 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Avi Kivity <avi@qumranet.com>,
       Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com> <46A4829C.9080104@qumranet.com> <20070723122510.GA3674@infradead.org>
In-Reply-To: <20070723122510.GA3674@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Jul 23, 2007 at 01:27:40PM +0300, Avi Kivity wrote:
>   
>> Having an address_space (like your patch does) is remarkably simple, and 
>> requires few hooks from the current vm.  However using existing vmas 
>> mapped by the user has many advantages:
>>     
>
> Actually it requires lots of deep down VM internals symbols that'll never
> get exported.
>
>   

What's "it" here?  kvm-specific address space or generic vmas.

Generic vmas will be more intrusive AFAICT.

-- 
error compiling committee.c: too many arguments to function

