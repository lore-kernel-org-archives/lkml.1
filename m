Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZICI6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZICI6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZICI6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:58:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:33453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbZICI6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:58:10 -0400
Message-ID: <4A9F8522.1010900@kernel.org>
Date: Thu, 03 Sep 2009 17:58:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [TOOL] matchreply: make procmail aware of threads and dups
References: <4A9F847C.60606@kernel.org>
In-Reply-To: <4A9F847C.60606@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 08:58:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> I've been reading the rather unfortunate LAK stuff on this week's LWN
> and it seems like other people are having similar problems with
> duplicated messages from different mailing lists.  Here's a program
> I've been using for a couple of years now to solve the issue.  It
> builds index of Maildir folders and can match for duplicates or a
> thread a message belongs to and very easy to use with procmail.
> 
> With proper procmailrc rules, this allows me not to worry about dups
> (there's race window and some might escape from time to time but no
> biggie) and easily follow the threads I'm interested in by simply
> moving the thread to one of the folders I keep closer eye on
> regardless of the actual target delivery addresses.
> 
> The attached tarball contains README but it's outdated and doesn't
> explain the -d option which matches for duplicates.
> 
> Here's my .procmailrc with some explanations which I grew over the
> years and am sure can be made much prettier somehow but it should show
> how it can be used.

Ooh.. right, one more thing.  To make the messages I wrote to be
filtered the same way, I disable the MUA from storing sent messages
directly and instead make it bcc myself, so that those end up in the
same folders as the threads they belong to.

Thanks.

-- 
tejun
