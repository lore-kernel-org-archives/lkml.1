Return-Path: <linux-kernel-owner+w=401wt.eu-S1751614AbXBCWEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbXBCWEN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 17:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbXBCWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 17:04:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10416 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXBCWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 17:04:12 -0500
Date: Sat, 3 Feb 2007 13:59:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A CodingStyle suggestion
Message-Id: <20070203135951.564e5fe2.randy.dunlap@oracle.com>
In-Reply-To: <20070203215848.GA10440@Ahmed>
References: <20070203215848.GA10440@Ahmed>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 23:58:48 +0200 Ahmed S. Darwish wrote:

> Hi all,
> 
> In CodingStyle Chapter 16 "Function return value and names", why not
> adding a comment about the favorable community way of checking the return
> value. ie:
> 
> ret = do_method();
> if (ret) {
>    /* deal with error */
> }
> 
> and not other ways like:
> 
> if (do_method()) or if ((ret = do_method()) > value) ...
> 
> A patch is ready if the replies are positive.

I like it.  Please cc: Andrew Morton <akpm@osdl.org> on it.
Hopefully he will merge it.

---
~Randy
