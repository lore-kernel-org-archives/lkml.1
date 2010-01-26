Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756Ab0AZBTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0AZBTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287Ab0AZBTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:19:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab0AZBTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:19:13 -0500
Message-ID: <4B5E401C.1050605@zytor.com>
Date: Mon, 25 Jan 2010 17:06:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, fweisbec@gmail.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, cl@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] percpu: add __percpu sparse annotations to x86
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-6-git-send-email-tj@kernel.org>
In-Reply-To: <1264432935-10453-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2010 07:22 AM, Tejun Heo wrote:
> 
> In arch/x86/kernel/cpu/common.c, per_cpu(exception_stacks, cpu) is
> replaced with &per_cpu(exception_stacks[0], cpu) which is equivalent
> except that it allows per_cpu() macro to correctly drop percpu
> designation during sparse pass.
> 

Same comment as Frederic's about this... this kind of uglification
really is unacceptable and needs to be addressed.

Other than that, it looks good.

	-hpa
