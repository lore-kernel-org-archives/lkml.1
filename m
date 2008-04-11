Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbYDKJLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbYDKJLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbYDKJLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:11:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:44817 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbYDKJLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZsL86DdkICIcjNVLmhAW0FOnqutRhlziBlF0TBPEAQyht6NzazcD1KKQmWw6yAL4prVwmnI4iGoQt0BjKEOPiII9zqBX3L4fejh06NyQw+WoMLj3BUGv9N6JXjMnxEbgOSwdp/QIKQ8UJvt4pMMx9jXn1EqcWwVC0l64QjkHkwI=
Message-ID: <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
Date: Fri, 11 Apr 2008 12:11:45 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
In-Reply-To: <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411074145.GA4944@elte.hu>
	 <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
	 <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
	 <20080411085411.GA10181@elte.hu>
	 <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
	 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
X-Google-Sender-Auth: 5652fdeedb39502f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 12:05 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>  >  Right. Then you probably want to look into any changes in arch/x86/
>  >  related to setting up the zonelists. I'm fairly certain this is not a
>  >  slab bug and I don't see any recent changes to the page allocator
>  >  either that would explain this.
>
>  I'd be willing to put some money on this:
>
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b7ad149d62ffffaccb9f565dfe7e5bae739d6836

And I'd lose as you're 32-bit. Oh well, that's the price to pay for
pretending to know x86 arch internals.
