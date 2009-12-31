Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZLaDEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZLaDEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 22:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZLaDEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 22:04:21 -0500
Received: from mail.tmr.com ([64.65.253.246]:43199 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbZLaDEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 22:04:20 -0500
Message-ID: <4B3C14B2.8020902@tmr.com>
Date: Wed, 30 Dec 2009 22:04:18 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Q. d_alloc() in pipe(2)
References: <20021.1262066120@jrobl>
In-Reply-To: <20021.1262066120@jrobl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote:
> In pipe(2), create_write_pipe() creates a dentry by
> 	struct qstr name = { .name = "" };
> 	d_alloc(root, &name);
> 
> But d_alloc() refers name->len which is uninitialized.
> Isn't it better to replace d_alloc() by d_alloc_name(root, "")?
> 
If readability counts, I would say so. Functionally I don't know, I can't see 
any problems other than it's unobvious.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
