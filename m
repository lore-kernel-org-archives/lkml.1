Return-Path: <linux-kernel-owner+w=401wt.eu-S944345AbXHMP0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944345AbXHMP0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972820AbXHMNWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:22:09 -0400
Received: from il.qumranet.com ([82.166.9.18]:45057 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S972815AbXHMNWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:22:07 -0400
Message-ID: <46C05B07.1090206@qumranet.com>
Date: Mon, 13 Aug 2007 16:22:15 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <46C00FC1.1070306@qumranet.com> <46C012A8.2040908@bull.net> <46C01877.7060007@qumranet.com> <46C057C0.7020003@bull.net>
In-Reply-To: <46C057C0.7020003@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:

  

>> Are these options for using the kernel as a guest or host?  I'd guess
>> the former.
>>     
>
> I didn't find CONFIG_HYPERVISOR.
>   

I meant, add a new option CONFIG_HYPERVISOR.

> The good one seems to be CONFIG_VIRTUALIZATION that is used to activate CONFIG_KVM.
>   

It's just a menu.  Right now there's just one entry, but it will 
change.  And if CONFIG_VIRTUALIZATION is selected, it doesn't mean 
CONFIG_KVM is selected.

-- 
error compiling committee.c: too many arguments to function

