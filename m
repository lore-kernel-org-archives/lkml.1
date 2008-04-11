Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYDKJFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYDKJFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbYDKJFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:05:47 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:22682 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbYDKJFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oGHZSRJ11h3GhgGYq/2iyBYSd7ctDp/jnhJIZN0Ukdbh+LqBr8ecNwvi9s98qrAcPWelt94rYSAniH4E8l4mnG0v/eQI69lzflBJtzXXc6lFgXVAfjl0XZDdEI8AvyR908aTIsZXsmjlLnHP/2XkY315+UqH+UXugdXPEtNw2ew=
Message-ID: <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
Date: Fri, 11 Apr 2008 12:05:44 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Cc: linux-kernel@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080411085411.GA10181@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411074145.GA4944@elte.hu>
	 <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
	 <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
	 <20080411085411.GA10181@elte.hu>
X-Google-Sender-Auth: 9e0df9806cd302b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo.

On Fri, Apr 11, 2008 at 11:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  but ... as i said it in my report, this is a regression since v2.6.24 -
>  v2.6.24 (and a whole bunch of commits since then, i listed the IDs)
>  booted up fine. The commit ID you mention is: v2.6.23-4345-g523b945, way
>  earlier than the good commit IDs.
>
>  so this is a recent regression.

Right. Then you probably want to look into any changes in arch/x86/
related to setting up the zonelists. I'm fairly certain this is not a
slab bug and I don't see any recent changes to the page allocator
either that would explain this.
