Return-Path: <linux-kernel-owner+w=401wt.eu-S932467AbZJ0WDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbZJ0WDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZJ0WDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:03:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22352 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbZJ0WDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:03:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=XXVIY+xYnMQQIsfkSPhtaWJ1F4x6XCw3l4XYPq9UjTpJhEWqJXl89o1tF7xXA/gnW
	2p/m2ZzTZduVcTdSuRbEw==
MIME-Version: 1.0
In-Reply-To: <20091027193330.GB19379@elf.ucw.cz>
References: <20091022091333.GA31023@elf.ucw.cz>
	 <20091026234332.GB26583@kroah.com> <20091027001702.GA5019@elf.ucw.cz>
	 <20091027030039.GA6195@kroah.com> <20091027081921.GG5019@elf.ucw.cz>
	 <20091027165750.GA24477@kroah.com> <20091027193330.GB19379@elf.ucw.cz>
Date: Tue, 27 Oct 2009 15:03:08 -0700
Message-ID: <a55d774e0910271503u40184a37ub493cfb3ed37adba@mail.gmail.com>
Subject: Re: staging/dream: add gpio and pmem support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Petri Gynther <pgynther@google.com>, Chris Dibona <cdibona@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 12:33 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
> (Plus, of course I'd like some help, but google people seem very
> silent :-( ).

Hi Pavel,

The Android kernel team is completely buried in issues related to fall
09 devices -- we're just not going to have cycles for sorting out
stuff related to going upstream until we're past that (probably
mid-late November).  Yeah, this totally sucks, but that's where we
are.  We're definitely going to be rebasing all our working trees up
to 2.6.32/33 for the end of the year and doing a push to get more
stuff cleaned up and push towards mainline.

My hope remains that once we get more of the core msm support and
device support out there we can get patches send upstream more
incrementally in the future instead of these big blobs of code.  We
need to adjust our working model to be more involved with the mainline
day-by-day while still supporting "stable" branches that can make it
into production hardware.  Fun times.

Brian
