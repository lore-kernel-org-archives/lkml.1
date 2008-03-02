Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYCBRxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYCBRxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 12:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYCBRxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 12:53:35 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:50157 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbYCBRxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 12:53:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mpRVeI9LidHoHvC2phNSEZ1GisMSyUBjxCXIV78M1P2sgAVk1pBtNOHwe6bSxc8CYqx6Z1/w6Zutl2bhTDmmJiPq1gMY+Ad7JD+5YGO1Tqwi+3NOzjR0dA8m6Z+nkJXw65OmU8ckGRZXQGMG6Sf3c8ZuyDgdWYrUvUpkh7O/MQo=
Date: Sun, 2 Mar 2008 12:53:27 -0500
From: Joseph Fannin <jfannin@gmail.com>
To: Rick van Rein <rick@vanrein.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080302175326.GB32381@nineveh.local>
Mail-Followup-To: Rick van Rein <rick@vanrein.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20080302134221.GA25196@phantom.vanrein.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302134221.GA25196@phantom.vanrein.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 01:42:21PM +0000, Rick van Rein wrote:
> This is the latest version of the BadRAM patch, which makes it possible to
> run Linux on broken memory.  The patch supports the use of a lesser grade
> of memory, which could be marketed more cheaply and which would thereby
> decrease the environmental stress caused by the process of (memory) chip
> manufacturing.
>
> Over the years, feedback on this patch has invariably been positive and
> enthousiastic.  The patch, even though not part of mainstream Linux, still
> managed to make lots of people happy:
>  - schools and other low-budget computer users
>  - people with partially defective RAM soldered onto laptop motherboards
>  - people with one faulty address due to wiring faults on their motherboard
>  - people who find it environmentally insane to toss out 99.99%-good hardware
>
> The patch has been well-maintained over the years, mostly by volunteers
> who keep track of kernel updates.  The submitters have changed over the years,
> but there have always been volunteers jumping in, sometimes within hours after
> a new kernel appeared, and mostly within a day.  I have processed support
> requests and used them to learn and make the patch work optimally.  It is
> obvious to me that the patch is in good demand, and I think it earns to be
> included in the mainstream kernel.
>
> The current version supports ia32 and x86_64 architectures.  Others would
> be unpractical to add on a patch outside mainstream Linux, but it ought to
> be straightforward to add support for other architectures as well.
>
> For more information, read Documentation/badram.txt or visit the homepage
> for the patch, http://rick.vanrein.org/linux/badram/

This is a great feature for those of us who value their money more
than a few hours of time as well.  :-)

I would very much like to see this patch in mainline -- I've used it
to allow use of a marginally bad RAM stick in my home
workstation/fileserver, with great results (i.e. my FS never went
belly-up).

There have been times when I was reluctant to report bugs in a BadMEM
patched kernel, due to the patching, as well as times when I would
have liked to have stuck with my distro's kernel, but couldn't, 'cause
I needed to patch BadRAM in.

I haven't used BadRAM in a minute, nor read the patch.  ISTR that one
argument that has been historically made against this sort of thing is
that it would make bug reports unreliable.  But we have the taint
mechanism now, so that shouldn't be a showstopper -- if that's the
only argument, then set a new taint flag, please.

I've added a akpm to the CC list.

--
Joseph Fannin
jfannin@gmail.com

