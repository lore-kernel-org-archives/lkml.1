Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434Ab0AZCFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0AZCFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770Ab0AZCFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:05:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44335 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab0AZCFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:05:45 -0500
Date: Tue, 26 Jan 2010 02:04:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       davem@davemloft.net, netdev@vger.kernel.org, x86@kernel.org,
       mingo@redhat.com, dan.j.williams@intel.com, borislav.petkov@amd.com,
       ying.huang@intel.com, lenb@kernel.org, neilb@suse.de,
       cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to
	hw_breakpoint
Message-ID: <20100126020452.GB19799@ZenIV.linux.org.uk>
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3F2C.2010702@zytor.com> <4B5E4E12.7060900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E4E12.7060900@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 11:06:10AM +0900, Tejun Heo wrote:
> Hello,
> 
> On 01/26/2010 10:02 AM, H. Peter Anvin wrote:
> > A cast (using __typeof__) combined with an address space override?
> 
> That still puts the address specification at the wrong level.  The
> problem is that the __typeof__ would be an array type which itself
> doesn't have address space set but its members are in address space 3.
> So, you need to get *inside* the array type def to change that.  :-(

Could you post the actual definitions in one piece?  Would be easier to
discuss what's going on...
