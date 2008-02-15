Return-Path: <linux-kernel-owner+w=401wt.eu-S1764891AbYBOCyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764891AbYBOCyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYBOCyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:54:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbYBOCyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:54:05 -0500
Message-ID: <47B4FEBC.2020700@redhat.com>
Date: Thu, 14 Feb 2008 21:53:48 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next build status
References: <20080215114253.ddf3f929.sfr@canb.auug.org.au> <47B4E9CB.3090708@redhat.com> <20080215020511.GJ6887@bakeyournoodle.com>
In-Reply-To: <20080215020511.GJ6887@bakeyournoodle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Breeds wrote:
> On Thu, Feb 14, 2008 at 08:24:27PM -0500, Chris Snook wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Initial status can be seen here
>>> http://kisskb.ellerman.id.au/kisskb/branch/9/ (I hope to make a better
>>> URL soon).  Suggestions for more compiler/config combinations are
>>> welcome, but we can't necessarily commit to fulfilling all you
>>> wishes.  :-)
>>>
>> i386 allmodconfig please.
> 
> Wont i386 allmodconfig be equivalent to x86_64 allmodconfig?

Only if there are no bugs.

Driver code is most likely to trip over bitness/endianness bugs, and 
you've already got allmodconfig builds for be32, be64, and le64 
architectures.  Adding an le32 architecture (i386) completes the 
coverage of these basic categories.

	-- Chris
