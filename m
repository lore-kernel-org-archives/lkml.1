Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZHBTO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZHBTO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZHBTO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:14:56 -0400
Received: from thunk.org ([69.25.196.29]:43388 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZHBTO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:14:56 -0400
Date: Sun, 2 Aug 2009 15:14:39 -0400
From: Theodore Tso <tytso@mit.edu>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Problems with CONFIG_KVM_GUEST?
Message-ID: <20090802191439.GE15828@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Avi Kivity <avi@redhat.com>,
	linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <20090801212616.GD734@mit.edu> <4A755EB3.9080502@redhat.com> <20090802153238.GC15828@mit.edu> <4A75B56D.5070407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A75B56D.5070407@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 06:49:01PM +0300, Avi Kivity wrote:
>
> What's the host kernel version?
>
> We had problems with CONFIG_KVM_GUEST and PAE which were resolved in  
> 2.6.30-final but perhaps failed to trickle down to whatever you're  
> using.  The upstream commit is a8cd0244 ("KVM: Make paravirt tlb flush  
> also reload the PAE PDPTRs").

Commit ID 63f7a33, which is post 2.6.31-rc3.  I run bleeding edge
kernels.  :-)

I can try building a 2.6.30-final kernel and testing that as the
host if you think it might be a 2.6.31-rc regression.

       	  	   	    	 	      - Ted
