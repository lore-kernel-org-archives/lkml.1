Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZFTLDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZFTLDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZFTLDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:03:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42014 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZFTLDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:03:12 -0400
Message-ID: <4A3CC1FA.2070900@redhat.com>
Date: Sat, 20 Jun 2009 14:03:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v3] KVM support for 1GB pages
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2009 04:16 PM, Joerg Roedel wrote:
> Hi,
>
> this is the third version of the patches for KVM to support 1GB pages. Changes
> to the last version include:
>
> 	- changed reporting of 1GB page support to userspace to use
> 	  SUPPORTED_CPUID ioctl
> 	- added support for 1GB pages to the software page walker code too
>
> This code still only can make use of 1GB pages with nested paging enabled. I
> will give the shadow paging code another debug round soon. Please comment or
> consider to apply these patches.
>
>    

Can you describe how the code fails with shadow paging?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

