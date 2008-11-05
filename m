Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYKEQeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYKEQeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYKEQeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:34:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54484 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYKEQeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:34:04 -0500
Date: Wed, 5 Nov 2008 17:33:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] x86: disable virt on kdump and emergency_restart
Message-ID: <20081105163306.GA30018@elte.hu>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <49107E2C.8090803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49107E2C.8090803@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Eduardo Habkost wrote:
>> Hi,
>>
>> This is a new version of the series to disabling virtualization on kdump,
>> now extended to do the same tricks on emergency_restart() if needed.
>>   
>
> Looks good.  If you me to push it upstream, I'll need kexec/kdump 
> acks.  Otherwise, ack for the kvm bits.

general ack for the x86 bits, but i'm not sure whether we should be 
pushing this upstream so late in the cycle. If we do it in the next 
cycle then it's best we do it in the x86 tree, the KVM impact seems 
much smaller than the general x86 impact.

	Ingo
