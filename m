Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZDUTz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZDUTz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZDUTzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:55:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:24107 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZDUTzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:55:08 -0400
Message-ID: <49EE2497.3060009@codemonkey.ws>
Date: Tue, 21 Apr 2009 14:55:03 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] Add MCE support to KVM
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com> <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com> <49EDF057.9060501@codemonkey.ws> <49EDF287.9020908@redhat.com>
In-Reply-To: <49EDF287.9020908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>
>> So Avi, regardless of what interface is chosen for KVM, can you hold 
>> off applying these patches until there is a TCG implementation?  
>> Otherwise, we'll be playing catchup between kvm-userspace and 
>> upstream QEMU forever.
>
> I have a feeling we will anyway,

Not if we avoid committing things to kvm-userspace that would require 
major reworking to get into upstream QEMU.  Fixing these issues is much 
easier up front then down the road.

Regards,

Anthony Liguori

