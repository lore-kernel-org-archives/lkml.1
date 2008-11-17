Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYKQPNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYKQPNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYKQPM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:12:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52004 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYKQPM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:12:57 -0500
Message-ID: <492189C9.2000502@redhat.com>
Date: Mon, 17 Nov 2008 17:12:09 +0200
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
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com> <491FD283.60402@redhat.com> <20081117150427.GH4481@blackpad>
In-Reply-To: <20081117150427.GH4481@blackpad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> Because of their location, I thought svm.h and vmx.h had KVM-specific
> code. Now I've noticed they are independent from KVM. May I move svm.h
> and vmx.h to arch/x86/include/asm, then?
>   

Indeed the intent was to have these as hardware descriptions rather than 
bits of code.  So moving them to include/asm makes sense.

-- 
error compiling committee.c: too many arguments to function

