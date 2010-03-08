Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab0CHJjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:39:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab0CHJjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:39:35 -0500
Message-ID: <4B94C5D3.6070601@redhat.com>
Date: Mon, 08 Mar 2010 11:39:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/18] KVM: X86: Add KVM_CAP_SVM_CPUID_FIXED
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <1267643541-451-19-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267643541-451-19-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> This capability shows userspace that is can trust the values
> of cpuid[0x8000000A] that it gets from the kernel. Old
> behavior was to just return the host cpuid values which is
> broken because all additional svm-features need support in
> the svm emulation code.
>
>    

A think we can simply fix the bug and push the fix to the various stable 
queues.

-- 
error compiling committee.c: too many arguments to function

