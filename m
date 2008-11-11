Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYKKWnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYKKWnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYKKWnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:43:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYKKWnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:43:23 -0500
Message-ID: <491A0A8F.30805@redhat.com>
Date: Wed, 12 Nov 2008 00:43:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, aarcange@redhat.com,
       chrisw@redhat.com
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>	<1226409701-14831-2-git-send-email-ieidus@redhat.com>	<1226409701-14831-3-git-send-email-ieidus@redhat.com>	<1226409701-14831-4-git-send-email-ieidus@redhat.com> <20081111150345.7fff8ff2@bike.lwn.net>
In-Reply-To: <20081111150345.7fff8ff2@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
>> +static struct list_head slots;
>>     
>
> Some of these file-static variable names seem a little..terse...
>   

While ksm was written to be independent of a certain TLA-named kernel 
subsystem developed two rooms away, they share some naming... this 
refers to kvm 'memory slots' which correspond to DIMM banks.

I guess it should be renamed to merge_ranges or something.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

