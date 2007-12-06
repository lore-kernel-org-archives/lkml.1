Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbXLFDD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbXLFDD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbXLFDDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:03:00 -0500
Received: from ozlabs.org ([203.10.76.45]:34472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748AbXLFDC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:02:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] kbuild: implement modules.order
Date: Thu, 6 Dec 2007 14:02:53 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: WANG Cong <xiyou.wangcong@gmail.com>, sam@ravnborg.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       kay.sievers@vrfy.org, greg@kroah.com
References: <47555AF1.8090304@gmail.com> <20071205070127.GG2460@hacking> <47564F35.30706@gmail.com>
In-Reply-To: <47564F35.30706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061402.53850.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2007 18:11:49 Tejun Heo wrote:
> WANG Cong wrote:
> >>> I think, you forgot to free(3) the memory you calloc(3)'ed and
> >>> malloc(3)'ed above.
> >>
> >> It's a simple program where whole body is in main().  Why bother?
> >> What's the benefit of adding hash-table iterating free logic?
> >
> > Personally, I think memory leaks are bugs. And we hate bugs. ;)
>
> Trust me.  As a person buried alive in bug reports, I hate bugs too.  I
> just don't agree that this type of programs should free all its
> resources before exiting.  How about adding a comment saying /* we're
> going out anyway, don't bother freeing hashtable */?

I too once battled with the moral dilemma of freeing in programs that exit.

Then in 2001, I was moving out of a house which was to be demolished.  The 
landlord insisted that we pay for the carpets to be cleaned.  My wife still 
uses it as a canonical example of wasteful idiocy.

So I hope this has contributed to your enlightenment, as it did to mine.
Rusty.
