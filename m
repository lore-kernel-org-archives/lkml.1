Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYELEC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYELEC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbYELECT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:02:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:46022 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYELECS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QUimRhjffqWnaBc50IrWZY+/ZYSHfCn8iS65EVkGzJ9Glh+l2wqPzDmaa13okpl8eKjWlM7UdfIF0isvIP4bEsy9HqqVk8FhLNbfv9v54CcE663WzNR8+IL3Beom5Q/xhsqfSQd0Ag2/RpNyucqbFagbwD56QrC5uYpO6pi8z5s=
Date: Mon, 12 May 2008 11:59:57 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 1/9] fs/exec.c: export free_arg_pages
Message-ID: <20080512035957.GF2572@hacking>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102547782640-git-send-email-xiyou.wangcong@gmail.com> <20080510191251.GA13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510191251.GA13907@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 08:12:51PM +0100, Al Viro wrote:
>On Thu, May 08, 2008 at 09:52:26PM +0800, WANG Cong wrote:
>> free_arg_pages() is used to clean the pages allocated by copy_strings_kenrel().
>> Since copy_strings_kernel() is exported, so should be free_arg_pages().
>
>Not really.  free_arg_pages() cleans them all at once; copy_strings_kernel()
>adds to pile.  free_arg_pages() is called once for _all_ of them.  And that
>happens in fs/exec.c, so it doesn't need to be exported.

Yes, thanks.
I already saw your patch, looks better than mine. ;-)

-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
