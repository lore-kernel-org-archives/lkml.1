Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZFEJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZFEJtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZFEJtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:49:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:41660 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZFEJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WRvGann2YDdFAsFW2oF87h4RLnmApdtFeiSmHv2ABab7mVONK0UctMBs6/md6SbL8u
         5Z2Cww46tv06irY1qDRsjax3ZuDQcS3GiI8XgXh3sAUBnrQn9F/KhDH6UCR7zvx2NATR
         C0rGqz3DKbTRMPMHkNdJhk2a34JnHhS9yjAMs=
Date: Fri, 5 Jun 2009 17:51:55 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
	2.6.30-rc8.
Message-ID: <20090605095155.GC8354@cr0.nay.redhat.com>
References: <4A289928.7040508@oracle.com> <20090604223805.2962e826.akpm@linux-foundation.org> <4A28C262.5020605@oracle.com> <20090605075614.GC8171@cr0.nay.redhat.com> <4A28DDEB.4000409@oracle.com> <2375c9f90906050209h191df8fav36fc9507654c5ca6@mail.gmail.com> <20090605021424.ba352b0f.akpm@linux-foundation.org> <4A28E5C9.6010408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28E5C9.6010408@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 05:30:49PM +0800, Tao Ma wrote:
>>
>> Please send the boot logs: dmesg -s 1000000 > foo
> attached.

>#######high memory 18446612137615818752, size_t 18446612137615818752
>#######kcore size 5301604352, PAGE_OFFSET 0, PAGE_SIZE 4096


These two lines must be added by yourself...

What?!
How can PAGE_OFFSET be 0??
Can you show us these two printk() you just added?

And, the size of kcore is not the crazy number in the subject...
This one is much saner..
