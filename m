Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932Ab0ASH5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0ASH5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932Ab0ASH5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:57:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0ASH5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:57:50 -0500
Message-ID: <4B5565F5.5030304@redhat.com>
Date: Tue, 19 Jan 2010 09:57:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gleb Natapov <gleb@redhat.com>, Vadim Rozenfeld <vrozenfe@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: linux-next: kvm tree build failure
References: <20100119124259.e0d77b47.sfr@canb.auug.org.au>
In-Reply-To: <20100119124259.e0d77b47.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 03:42 AM, Stephen Rothwell wrote:
> Hi Avi,
>
> Today's linux-next build (x86_64 allmodconfig) failed like this:
>
> usr/include/asm/kvm_para.h:5: included file 'asm-x86/hyperv.h' is not exported
>
> Caused by commit 328aca1e523bedc49592bbdd65bedaa690b8df29 ("KVM:
> Implement bare minimum of HYPER-V MSRs").
>
> I have used the kvm tree from next-20100118 for today.
>    

Doh, I noticed it and forgot to port the commit to linux-next.

Marcelo, can you add 270d27e07d8 to the .34 queue?

(Stephen, please copy Marcelo on all kvm issues, we share maintainership 
by switching tree ownership at semi random points in time so I can't 
always do anything about the breakage personally).

-- 
error compiling committee.c: too many arguments to function

