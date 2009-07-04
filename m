Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZGDPUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZGDPUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 11:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZGDPUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 11:20:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56900 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZGDPUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 11:20:21 -0400
Message-ID: <4A4F732A.4050103@redhat.com>
Date: Sat, 04 Jul 2009 18:20:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Gleb Natapov <gleb@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v5] enable x2APIC without interrupt remapping under KVM
References: <20090701133007.GC27539@redhat.com> <1246482017.27006.10670.camel@localhost.localdomain> <20090703082905.GF21833@elte.hu>
In-Reply-To: <20090703082905.GF21833@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2009 11:29 AM, Ingo Molnar wrote:
> Now, since this affects core x86 APIC code non-trivially so should
> submitted to and go via the x86 tree. (Can prepare a special branch
> with just this change if KVM tree wants/needs to pull it before
> v2.6.32.)
>    

The kvm tree won't depend on this change.  I'm happy with it going into 
2.6.32 via tip.git.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

