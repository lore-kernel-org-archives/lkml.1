Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbXJBN1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbXJBN1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXJBN1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:27:10 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37180 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752958AbXJBN1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:27:09 -0400
Message-ID: <391331626.16970@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 2 Oct 2007 21:27:02 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Greg KH <gregkh@suse.de>,
       Chakri n <chakriin5@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Krzysztof Oledzki <olel@ans.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       richard kennedy <richard@rsk.demon.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] writeback: avoid possible balance_dirty_pages() lockup
	on a light-load bdi
Message-ID: <20071002132702.GA10967@mail.ustc.edu.cn>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <391063897.19256@ustc.edu.cn> <470118EE.1020103@redhat.com> <391290444.23950@ustc.edu.cn> <20071001191457.2f7c7538.akpm@linux-foundation.org> <20071002121327.GA5718@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002121327.GA5718@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 08:13:27PM +0800, Fengguang Wu wrote:
[...]
> One more serious problem is, a busy writer could also drain all the
> dirty pages and make (nr_writeback == dirty_limit+1MB). In that case,
> I suspect the light-load sdb writer still have good chance to
> make progress(need confirmation).

Well it seems to be a really tricky issue without knowing the per-bdi
numbers. Maybe we could just encourage users to upgrade to 2.6.24...

