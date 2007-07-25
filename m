Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbXGYHTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbXGYHTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXGYHTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:19:34 -0400
Received: from il.qumranet.com ([82.166.9.18]:60049 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbXGYHTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:19:33 -0400
Message-ID: <46A6F983.3040005@qumranet.com>
Date: Wed, 25 Jul 2007 10:19:31 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Shaohua Li <shaoh.li@gmail.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 4/8]KVM: move gfn_to_page out of kmap/unmap
 pars
References: <1185173499.2645.68.camel@sli10-conroe.sh.intel.com>	 <46A5C884.8060200@qumranet.com> <288dbef70707240618l71bd8678n28a39e663dab3c1c@mail.gmail.com>
In-Reply-To: <288dbef70707240618l71bd8678n28a39e663dab3c1c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 25 Jul 2007 10:19:32 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> 2007/7/24, Avi Kivity <avi@qumranet.com>:
>> Shaohua Li wrote:
>> > gfn_to_page might sleep with swap support. Move it out of the kmap
>> calls.
>> >
>> >
>>
>> I'd like to apply this to the kvm.git master branch so we don't have to
>> maintain it.  Was this tested on a highmem machine?  If not, I can do
>> it.
> My test system has 1G memory, so it should work. I only tested 32bit
> system, better check a x64 build.
>

This is now in, after minor merge fixups.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

