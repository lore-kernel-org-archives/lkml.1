Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYELDzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYELDzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 23:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYELDzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 23:55:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:15505 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYELDzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 23:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kWioLb3AU3aLjWyAasqbfeqrF7uZGxbproNaCZTMSQwbdWX8/H9BrDFTNmsdxs4S+8i4IVXwqSdL1DuzoWKq9x6mymU/Heb0AlkRvJK8NC5uHfjM7Jx4kxIB4edb2i0EIZycBmihKcO5VVv+iidvZn2C4z912tThy0Sk5uElesE=
Date: Mon, 12 May 2008 11:53:47 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 5/9] fs/binfmt_em86.c: fix resource leaks
Message-ID: <20080512035347.GD2572@hacking>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548313018-git-send-email-xiyou.wangcong@gmail.com> <20080510192509.GE13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510192509.GE13907@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 08:25:09PM +0100, Al Viro wrote:
>On Thu, May 08, 2008 at 09:52:30PM +0800, WANG Cong wrote:
>>  ->load_binary()'s caller only frees resources which ->load_binary() applied
>> when it succeeded, so ->load_binary() itself should free the resources on
>> failure.
>
>No, it should not.  do_execve() will free them just fine.

Oh, yes. I missed this. So 4,5,6 should be dropped.

Thanks!

-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
