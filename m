Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbXJWOk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbXJWOk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbXJWOkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:40:21 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60362 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751817AbXJWOkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:40:19 -0400
Message-ID: <393150419.31806@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 23 Oct 2007 22:40:14 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chris Mason <chris.mason@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Mahoney <jeffm@suse.com>, reiserfs-dev@namesys.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] reiserfs: don't drop PG_dirty when releasing
	sub-page-sized dirty file
Message-ID: <20071023144014.GA6174@mail.ustc.edu.cn>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221258.11384.maximlevitsky@gmail.com> <393051953.24752@ustc.edu.cn> <200710221421.21439.maximlevitsky@gmail.com> <393126119.26275@ustc.edu.cn> <1193134027.7406.1.camel@twins> <393140585.27414@ustc.edu.cn> <20071023101053.638fe207@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023101053.638fe207@think.oraclecorp.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:10:53AM -0400, Chris Mason wrote:
> On Tue, 23 Oct 2007 19:56:20 +0800
> Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > On Tue, Oct 23, 2007 at 12:07:07PM +0200, Peter Zijlstra wrote:
> > > [ adding reiserfs devs to the CC ]
> > 
> > Thank you.
> > 
> > This fix is kind of crude - even when it fixed Maxim's problem, and
> > survived my stress testing of a lot of patching and kernel compiling.
> > I'd be glad to see better solutions.
> 
> This should be safe, reiserfs has the buffer heads themselves clean and
> the page should get cleaned eventually.  The cancel_dirty_page call was
> just an optimization to be VM friendly.
 
> -chris

'chris' as in fs/reiserfs/{inode.c,namei.c}, and now in btrfs/*?

Nice to meet you ;-)

Fengguang

