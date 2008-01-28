Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYA1MjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYA1MjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYA1MjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:39:00 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:19837 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYA1Mi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:38:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DwFFBXwgaA5alG5U3muv3O86gBG5wBUBUlqduVH/kzad2Bi8JwE92TVW/JttKfRbekQDY6nLyYscDKScNMY+6ZGkWX/OHxXXbCC7pRormPM/jevPoVRYpTcJ6ev6Xa8S7eHbfLTIZFWT4+FI7AnCod+B4r0dAJrfu9Xohn7g83o=
Message-ID: <28c262360801280438s59b6957bnffa5f3cf75f93014@mail.gmail.com>
Date: Mon, 28 Jan 2008 21:38:57 +0900
From: "minchan kim" <minchan.kim@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove duplicating priority setting in try_to_free_p
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Martin Bligh" <mbligh@mbligh.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20080128010102.8cbcbdda.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <28c262360801252329q7232edc2l2d0e4ed17c054832@mail.gmail.com>
	 <20080127213312.517b8014.akpm@linux-foundation.org>
	 <28c262360801272243h71bf4464s431d1377051c756b@mail.gmail.com>
	 <20080128010102.8cbcbdda.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with you.
If you will have a test result, Let me know it.

On Jan 28, 2008 6:01 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 28 Jan 2008 15:43:56 +0900 "minchan kim" <minchan.kim@gmail.com> wrote:
>
> > > I think this is actually a bugfix.  The code you're removing doesn't do the
> > >
> > >         if (priority < zone->prev_priority)
> > >
> > > thing.
> > >
> >
> > shrink_zones() in try_to_free_pages() already called
> > note_zone_scanning_priority().
> > So, it have done it.
>
> note_zone_scanning_priority() will only permit ->prev_priority to logically
> increase, whereas the code which you've removed will also permit
> ->prev_priority to logically decrease.  So I don't see that they are
> equivalent?
>
>



-- 
Kinds regards,
barrios
