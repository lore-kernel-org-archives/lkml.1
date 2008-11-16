Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYKPH7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYKPH7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYKPH6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:58:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36137 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYKPH6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:58:51 -0500
Message-ID: <491FD283.60402@redhat.com>
Date: Sun, 16 Nov 2008 09:57:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86: disable virt on kdump and emergency_restart
 (v3)
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> Hi,
>
> This is a new spin of the series to disable vmx on kdump and on
> emergency_restart. Now we avoid doing the function pointer stuff by
> moving 4 small KVM functions to a header, as inline functions. The code
> looks much simpler now, but we have to be more careful because some
> additional code will run on kdump and reboot even when KVM is never
> loaded.
>
> I haven't tested the SVM changes on AMD CPUs. The changes are really
> simple, but some testing is welcome.
>
> This series is against tip.git#master, that already contains the
> nmi_shootdown_cpus() changes I've submitted previously.
>
>
>   

Looks good.  I am slightly uneasy about moving things away from vmx.h 
and svm.h; can we keep them there and #include those headers directly?

-- 
error compiling committee.c: too many arguments to function

