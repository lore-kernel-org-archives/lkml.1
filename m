Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYKFJu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYKFJu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYKFJuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:50:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51332 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbYKFJuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:50:18 -0500
Message-ID: <4912BDC5.3000508@redhat.com>
Date: Thu, 06 Nov 2008 11:49:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eduardo Habkost <ehabkost@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] x86: disable virt on kdump and emergency_restart
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <49107E2C.8090803@redhat.com> <20081105163306.GA30018@elte.hu>
In-Reply-To: <20081105163306.GA30018@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> general ack for the x86 bits, but i'm not sure whether we should be 
> pushing this upstream so late in the cycle. If we do it in the next 
> cycle then it's best we do it in the x86 tree, the KVM impact seems 
> much smaller than the general x86 impact.
>   

It certainly doesn't fall under the recent regression rule, and there's 
a simple workaround (rmmod -r kvm) so I agree it's best to defer for the 
next cycle.

-- 
error compiling committee.c: too many arguments to function

