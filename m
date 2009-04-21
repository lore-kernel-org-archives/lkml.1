Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZDUQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZDUQTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZDUQTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:19:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34136 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbZDUQTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:19:41 -0400
Message-ID: <49EDF217.2080204@redhat.com>
Date: Tue, 21 Apr 2009 19:19:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDEF18.20107@codemonkey.ws>
In-Reply-To: <49EDEF18.20107@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
>> You also need to inject the MCE.
>
> KVM_SET_EXCEPTION, instead of adding something MCE specific?

That's of dubious use... exceptions are cpu-internal things.  It's also 
problematic to implement - what do you do if an exception is already 
pending?  For MCE you know it's priority (think it overrides almost 
everything).

I would really like to have a well defined boundary.

-- 
error compiling committee.c: too many arguments to function

