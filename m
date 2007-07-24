Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbXGXJiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbXGXJiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761062AbXGXJiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:38:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:34062 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761335AbXGXJiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:38:04 -0400
Message-ID: <46A5C884.8060200@qumranet.com>
Date: Tue, 24 Jul 2007 12:38:12 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 4/8]KVM: move gfn_to_page out of kmap/unmap pars
References: <1185173499.2645.68.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185173499.2645.68.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> gfn_to_page might sleep with swap support. Move it out of the kmap calls.
>
>   

I'd like to apply this to the kvm.git master branch so we don't have to 
maintain it.  Was this tested on a highmem machine?  If not, I can do it.


-- 
error compiling committee.c: too many arguments to function

