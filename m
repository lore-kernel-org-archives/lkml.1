Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab0BYKco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:32:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759104Ab0BYKcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:32:42 -0500
Message-ID: <4B8651C5.1020209@redhat.com>
Date: Thu, 25 Feb 2010 12:32:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] Another set of nested svm fixes and optimizations
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 07:59 PM, Joerg Roedel wrote:
> Hi,
>
> here is another set of patches I collected in the last days while trying
> to get Hyper-V running with nested svm. I was not successful yet but the
> patches in this set make sense anyway :-)
> The patches fix coding style issues which annoyed me for some time
> because my vim shows all c-space-errors with red color. Other patches in
> this set make nested svm more complete (nmi and selective cr0 related).
> The vm_cr and hwcr.ignne patches are related to Hyper-V tests. This
> hypervisor expects to write to those msrs.
> The most interesting thing is patch 11 which reduces the amount of
> memory which is touched in the vmrun emulation for merging the msrpms
> from 24kb to 48 bytes.  Please review and comment (or apply if
> perfect ;-) ) these patches.
>    

1-10 applied.  11 had about 32 suggestions for improvement, please pick 
one and resubmit.

-- 
error compiling committee.c: too many arguments to function

