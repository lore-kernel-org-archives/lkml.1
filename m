Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZJLJ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZJLJ0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZJLJ0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbZJLJ0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:26:34 -0400
Message-ID: <4AD2F62A.5010704@redhat.com>
Date: Mon, 12 Oct 2009 11:26:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9 v3] KVM: Nested SVM fixes and tracepoint conversion
References: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 04:08 PM, Joerg Roedel wrote:
> Hi Avi, Marcelo,
>
> this series of patches contains bugfixes for the Nested SVM code and the
> conversion of Nested SVM debugging to tracepoints. The fixes are:
>
> 	1) A patch Alex already sent (1/9) but which was not yet
> 	   applied. It fixes a lost event_inj problem when we emulate a
> 	   vmrun and a vmexit without entering the guest in the
> 	   meantime.
>
> 	2) The patch 2/9 fixes a schedule() while atomic bug in the
> 	   Nested SVM code. The KVM interrupt injection code runs with
> 	   preemtion and interrupts disabled. But the
> 	   enable_irq_window() function from SVM may emulate a #vmexit.
> 	   This emulation might sleep which causes the schedule() while
> 	   atomic() bug.
>
> These fixes (patches 1 and 2) should also be considered for -stable
> backporting.  The patches 3 to 8 convert the old printk based debugging
> for Nested SVM to tracepoints.  Patch 9 removes the nsvm_printk code.
> Please review and/or consider to apply these changes.
>    

Looks good to me.

-- 
error compiling committee.c: too many arguments to function

