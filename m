Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYGCVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYGCVcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYGCVcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:32:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:6169 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbYGCVcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kYXNbkuJW5ZeH2WVbU0ZPLqJ2SruqYAmJdHMZxlH/TrAlYIpkEfeL98du1w91ksvBh
         2KW/LK8jnaXoqH4uZq1vkrKAtpYu52aL+aVHXwmru3aG9q6bxIMtzGlw8SIyiIK8RiG8
         VqK3ZN+I8Cs4zX0nBKcT4dgcyfxgw73eILHgs=
Message-ID: <86802c440807031432j6083b930y6e894b62fab041bd@mail.gmail.com>
Date: Thu, 3 Jul 2008 14:32:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH] x86: make e820_saved have update from setup_data
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "Ying Huang" <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080703230108.1dbe68cb@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807031135.37465.yhlu.kernel@gmail.com>
	 <200807031137.13984.yhlu.kernel@gmail.com>
	 <20080703230108.1dbe68cb@kopernikus.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 2:01 PM, Bernhard Walle <bwalle@suse.de> wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> [2008-07-03 11:37]:
>>
>> +     /* update the e820_saved too */
>> +     e820_reserve_setup_data();
>
> Why do you want to update the e820_saved here? /sys/firmware/memmap
> should provide the real BIOS-provided memory map, IMO ...

that setup_data is another half memmap for efi.

YH
