Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYKEOor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYKEOor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYKEOoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:44:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50671 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYKEOog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:44:36 -0500
Date: Wed, 5 Nov 2008 09:44:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Haren Myneni <hbabu@us.ibm.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
       mingo@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] x86: disable virt on kdump and emergency_restart
Message-ID: <20081105144412.GD8993@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <49107E2C.8090803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49107E2C.8090803@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 06:54:04PM +0200, Avi Kivity wrote:
> Eduardo Habkost wrote:
>> Hi,
>>
>> This is a new version of the series to disabling virtualization on kdump,
>> now extended to do the same tricks on emergency_restart() if needed.
>>   
>
> Looks good.  If you me to push it upstream, I'll need kexec/kdump acks.   
> Otherwise, ack for the kvm bits.

Looks good to me from kdump perspective.

Is there a way we can prevent any other module from using virt disable
callback incase kvm is not loaded?

Thanks
Vivek
