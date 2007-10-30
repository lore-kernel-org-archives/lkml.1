Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXJ3TOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXJ3TOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbXJ3TOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:14:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757185AbXJ3TOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:14:07 -0400
Date: Tue, 30 Oct 2007 12:11:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: Karl Schendel <kschendel@datallegro.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
In-Reply-To: <47277BDA.6070702@oracle.com>
Message-ID: <alpine.LFD.0.999.0710301206390.30120@woody.linux-foundation.org>
References: <47225835.4050309@datallegro.com>
 <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org>
 <47226A75.1020008@oracle.com> <alpine.LFD.0.999.0710261541410.30120@woody.linux-foundation.org>
 <47227015.6060708@oracle.com> <alpine.LFD.0.999.0710261611511.30120@woody.linux-foundation.org>
 <47227813.7040604@datallegro.com> <47277BDA.6070702@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Zach Brown wrote:
>
> OK, I tested and verified Karl's fix and wrote some commentary around it.

Thanks, will apply.

> (Would a aio-dio git repo on kernel.org for these kind of fixes be well
> received?)

If it's one of these "in a blue moon" things I don't think it matters. 
Whatever is easier. 

In general, patches have lots of advantages: (a) you can apply it 
regardless of version, and (b) pushing the email containing them back and 
forth with commentary etc is very powerful.

So I would generally see git as a "maintainer handling issue", not a 
"these kinds of fixes" issue. Git doesn't obviate the need for having 
people look at patches (and that implies sending them out). But git _is_ a 
good way to push the finished product out, if it's a recurring thing.

		Linus
