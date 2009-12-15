Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZLODg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZLODg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbZLODg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:36:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZLODg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:36:27 -0500
Message-ID: <4B2704B2.10709@redhat.com>
Date: Mon, 14 Dec 2009 17:38:26 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Adjust tsc_offset only if tsc_unstable
References: <1260789740-14847-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1260789740-14847-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 01:22 AM, Joerg Roedel wrote:
> The tsc_offset adjustment in svm_vcpu_load is executed
> unconditionally even if Linux considers the host tsc as
> stable. This causes a Linux guest detecting an unstable tsc
> in any case.
> This patch removes the tsc_offset adjustment if the host tsc
> is stable. The guest will now get the benefit of a stable
> tsc too.
>
>    
Hi Joerg, I have a much more comprehensive series of patches to address 
this issue, please take a look.

Thanks,

Zach
