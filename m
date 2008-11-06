Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYKFM3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYKFM3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYKFM3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:29:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48167 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbYKFM3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:29:09 -0500
Date: Thu, 6 Nov 2008 10:28:00 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] x86: disable virt on kdump and emergency_restart
Message-ID: <20081106122800.GN5247@blackpad>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <49107E2C.8090803@redhat.com> <20081105163306.GA30018@elte.hu> <4912BDC5.3000508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4912BDC5.3000508@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 11:49:57AM +0200, Avi Kivity wrote:
> Ingo Molnar wrote:
>> general ack for the x86 bits, but i'm not sure whether we should be  
>> pushing this upstream so late in the cycle. If we do it in the next  
>> cycle then it's best we do it in the x86 tree, the KVM impact seems  
>> much smaller than the general x86 impact.
>>   
>
> It certainly doesn't fall under the recent regression rule, and there's  
> a simple workaround (rmmod -r kvm) so I agree it's best to defer for the  
> next cycle.

Shouldn't reboot=kbd be the default again still during this cycle, then?

The cases where the new reboot=acpi default broke didn't necessarily
involve KVM.

-- 
Eduardo
