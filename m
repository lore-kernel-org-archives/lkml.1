Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169Ab0AZCBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0AZCBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279Ab0AZCBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:01:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:42585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab0AZCBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:01:19 -0500
Message-ID: <4B5E4E12.7060900@kernel.org>
Date: Tue, 26 Jan 2010 11:06:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, rusty@rustcorp.com.au, akpm@linux-foundation.org,
       ebiederm@xmission.com, tytso@mit.edu, Trond.Myklebust@netapp.com,
       aelder@sgi.com, hch@infradead.org, viro@zeniv.linux.org.uk,
       davem@davemloft.net, netdev@vger.kernel.org, x86@kernel.org,
       mingo@redhat.com, dan.j.williams@intel.com, borislav.petkov@amd.com,
       ying.huang@intel.com, lenb@kernel.org, neilb@suse.de,
       cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to	hw_breakpoint
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3F2C.2010702@zytor.com>
In-Reply-To: <4B5E3F2C.2010702@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jan 2010 01:59:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/26/2010 10:02 AM, H. Peter Anvin wrote:
> A cast (using __typeof__) combined with an address space override?

That still puts the address specification at the wrong level.  The
problem is that the __typeof__ would be an array type which itself
doesn't have address space set but its members are in address space 3.
So, you need to get *inside* the array type def to change that.  :-(

Thanks.

-- 
tejun
