Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXJVN32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXJVN32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXJVN3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:29:11 -0400
Received: from tachyon.jukie.net ([205.150.199.214]:57992 "EHLO jukie.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752914AbXJVN3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:29:10 -0400
Date: Mon, 22 Oct 2007 09:28:20 -0400
From: Bart Trojanowski <bart@jukie.net>
To: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Cc: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [BUG] 2.6.23.1 host freezes when running kvm
Message-ID: <20071022132820.GA3962@jukie.net>
References: <20071019202019.GW3962@jukie.net> <20071020000240.GX3962@jukie.net> <20071020154445.GA5254@jukie.net> <471B366B.7040706@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471B366B.7040706@qumranet.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@qumranet.com> [071021 07:23]:
> Does 2.6.23 hang immediately?  If so, these may be two separate problems 
> and it's worth bisecting to find out what's the fix in 2.6.24-rc.
> 
> Of course we'll have to address the later hang as well.

Avi,

it does not hang immediately.  It seems to wait until I go to bed to
hang -- so it's going to be really fun to rebase.  It could be triggered
by something that runs off cron in the guest or host.  I am not sure.  

At this point I know that 2.6.23 and 2.6.24-rc0 hung, and 2.6.22.10
(with kvm-userspace.git) ran overnight.

I will try some of the 23-rc's next.

-Bart

-- 
				WebSig: http://www.jukie.net/~bart/sig/
