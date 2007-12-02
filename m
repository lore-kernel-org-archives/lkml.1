Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXLBSFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXLBSFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXLBSFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:05:44 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:40032 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbXLBSFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Zl4Ds+Vv/SPgZsrn0M0iez8uHTL5Cj7SqXJcndZOc/XgDOLrIZjk5tCbkLnpmfzcRaYyw99hkf9Gr0fXdxjOD4xYlvkfdCglyFPKGT7YrK4tDZ9JvL/HneMmoz/VMSLnCVV2100g1gr7fQ994pJbyuif19XZGKJ+pUV2wUJYQ9o=
Date: Sun, 2 Dec 2007 21:05:29 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Tuttle <linux-kernel@ttuttle.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops with 2.6.24 git when loading iwl3945
Message-ID: <20071202180529.GC7377@cvg>
References: <1196196237.19410.1223544787@webmail.messagingengine.com> <20071202164316.GB7377@cvg> <1196617561.16481.1224371239@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196617561.16481.1224371239@webmail.messagingengine.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Tuttle - Sun, Dec 02, 2007 at 12:46:01PM -0500]
| On Sun, 2 Dec 2007 19:43:16 +0300, "Cyrill Gorcunov"
| <gorcunov@gmail.com> said:
| > [Thomas Tuttle - Tue, Nov 27, 2007 at 03:43:57PM -0500]
| > | Hey.
| > | 
| > | I'm using a git snapshot that gentoo distributed mere hours ago (so I'm
| > | fairly confident it's current), and I'm getting an Oops when I try to
| > | load the iwl3945 driver.  I've attached it as plain text.
| > | 
| > | Hope this helps,
| > | 
| > | Thomas Tuttle
| > 
| > Hi Thomas,
| > Could you please test the patch?
| 
| It didn't help.  The original oops says the problem was in strcmp.  It
| was a GPF, which suggests to me that one of the arguments is NULL. 
| Since ops->name is checked at the beginning of the function, the only
| other possibility is that alg->ops->name is NULL.  I added a bit of code
| to check for this, and it turns out that one of the strings was indeed
| NULL.  I didn't know where to go from there in debugging, but I hope it
| helps.
| 
| Thanks,
| 
| Thomas Tuttle
| 

thanks, i do know that problem is in strcmp, i just thought the reason
of bug was a delayed procedure execution 'case of missing mutex unlock.
Have to dig deeper ;)

		Cyrill

