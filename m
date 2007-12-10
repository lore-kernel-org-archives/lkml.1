Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbXLJI1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbXLJI1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXLJI1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:27:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:54902 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbXLJI1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=R9WvU6R7Rgv+LLpbRmwXwqwrZ+Nqv2zACjqV+r93FjljGVDBTQsNRwKe5qVLbzJmOhktUZgugD+lVzzIWQ5/n/01XwZfSNVn8XpT440HajqCNulw4tyFMB+fkmLrBNB8Sg3Ulkfp9OTb8rJNQ+AoJy1PX95SGf5MtGOTcW8UVzQ=
Message-ID: <475CF861.5080804@gmail.com>
Date: Mon, 10 Dec 2007 17:27:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <200712080340.49546.rjw@sisk.pl> <20071208015227.3a1c7fae.akpm@linux-foundation.org> <475B9270.6070902@gmail.com> <20071209134217.7ff02dd2@the-village.bc.nu> <alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org> <20071209220132.53268368@the-village.bc.nu> <alpine.LFD.0.9999.0712091736450.12046@woody.linux-foundation.org> <20071210082157.GA21564@elte.hu>
In-Reply-To: <20071210082157.GA21564@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> Tejun already reported that this apparently gets fixed _properly_ with 
>> the more extensive cleanups and fixes that are pending for 2.6.25.
> 
> btw., how extensive are those cleanups and fixes in reality, is there a 
> rollup somewhere one could take a look at? Those fixes and cleanups were 
> deferred to v2.6.25 in the knowledge of having the current code included 
> in v2.6.24 - but now that the current approach seems to regress, maybe 
> those cleanups are still safe enough. (compared to an outright revert)

The following git tree contains patches pending review for 2.6.25.

http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=shortlog;h=improve-ATAPI-data-transfer-no-pio

And we're getting close to fixing the regression.  I don't think there's
too much worry about this one.  Just need a bit more time to test few
more things.

Thanks.

-- 
tejun
