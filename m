Return-Path: <linux-kernel-owner+w=401wt.eu-S933240AbZFQNuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbZFQNuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZFQNuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:50:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZFQNuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:50:05 -0400
Message-ID: <4A38F47F.509@redhat.com>
Date: Wed, 17 Jun 2009 16:49:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: linux-next: kvm/powerpc tree build failure
References: <20090617150419.e406a69a.sfr@canb.auug.org.au>
In-Reply-To: <20090617150419.e406a69a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2009 08:04 AM, Stephen Rothwell wrote:
> From: Stephen Rothwell<sfr@canb.auug.org.au>
> Date: Wed, 17 Jun 2009 14:57:29 +1000
> Subject: [PATCH] kvm/powerpc: make 32 bit constant unsigned long
>
> KVM_PAGES_PER_HPAGE needs to be unsigned long since its value is 2^31.
>
> Eliminates this compiler warning:
>
>    

Thanks, applied.  For some reason my own build testing didn't fail on this.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

