Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbYBWO4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbYBWO4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYBWO4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:56:25 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33905 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYBWO4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:56:24 -0500
Date: Sat, 23 Feb 2008 07:56:23 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: David Newall <davidn@davidnewall.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: Accessor macros vs reference counting
Message-ID: <20080223145623.GK16995@parisc-linux.org>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com> <12037544671847-git-send-email-xiyou.wangcong@gmail.com> <1203754478165-git-send-email-xiyou.wangcong@gmail.com> <1203754488669-git-send-email-xiyou.wangcong@gmail.com> <12037544991876-git-send-email-xiyou.wangcong@gmail.com> <1203754509934-git-send-email-xiyou.wangcong@gmail.com> <20080223090613.GJ16995@parisc-linux.org> <47C0159E.5020806@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C0159E.5020806@davidnewall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 11:16:22PM +1030, David Newall wrote:
> Is get_personality() thought to be better than current->personality?  To
> me, the latter seems more meaningful, and I'd rather see it than the former.

I suppose it's possible we might want to move 'personality' out of
'current' one day, and having an accessor macro makes it easier to do
that.  I agree it doesn't seem like a big win though.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
