Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXJBSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXJBSh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXJBShU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:37:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbXJBShU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:37:20 -0400
Message-ID: <47028F85.4030708@redhat.com>
Date: Tue, 02 Oct 2007 14:35:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Chakri n <chakriin5@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Krzysztof Oledzki <olel@ans.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       richard kennedy <richard@rsk.demon.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] writeback: avoid possible balance_dirty_pages() lockup
 on a light-load bdi
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <391063897.19256@ustc.edu.cn> <470118EE.1020103@redhat.com> <391290444.23950@ustc.edu.cn> <20071001191457.2f7c7538.akpm@linux-foundation.org> <20071002121327.GA5718@mail.ustc.edu.cn> <391331626.16970@ustc.edu.cn>
In-Reply-To: <391331626.16970@ustc.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2007 09:27 AM, Fengguang Wu wrote:
> On Tue, Oct 02, 2007 at 08:13:27PM +0800, Fengguang Wu wrote:
> [...]
>> One more serious problem is, a busy writer could also drain all the
>> dirty pages and make (nr_writeback == dirty_limit+1MB). In that case,
>> I suspect the light-load sdb writer still have good chance to
>> make progress(need confirmation).
> 
> Well it seems to be a really tricky issue without knowing the per-bdi
> numbers. Maybe we could just encourage users to upgrade to 2.6.24...
> 

Yeah, and if that doesn't work there's always 2.6.25... :/

