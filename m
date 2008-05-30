Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbYE3APg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbYE3APg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYE3APZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:15:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:29645 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbYE3APY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ItFM5gdNoAzWi1ohQrb4vD04w4Q5bh7uyMQKye8JyXwwRgcgPDScuoX5F8GCIhufOy1lYZl5Bx1Ci7bZOmY9UgmnHLK/0gtAHc0Dx77VF/iWGQOH+jXbMRwPnqWuSIbUePjmA8dBHK7vuwsywX2bVjKsAVzAyGdMz2/+/Q1rxtI=
Message-ID: <efc7ee340805291715h8a22d32jad191be9650bbfeb@mail.gmail.com>
Date: Thu, 29 May 2008 17:15:18 -0700
From: Leonid <leonidv11@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
Cc: "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <200805291448.40075.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080529212110.GA2870@suse.de>
	 <200805291448.40075.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Sure, I somewhat understand your concerns about the timeout change,
but we responded to an email form you over a week ago and never
received a reply regarding our viewpoint.  It was sent to your
personal email address as well as to the public linux-usb list.
Please refer to the email titled "[PATCH 5/5] EHCI: fix performance
regression" dated Wed, May 21, 2008 at 12:02 PM.  In that email, we
state that it doesn't make sense to reduce the timeout to 3ms and we
still don't have a full understanding of why increasing it to 10 ms is
such a bad idea.

While we had initially been discussing this bug with you over private
emails, once we lost touch with you, we resolved it in close
collaboration with Alan.  We have spent many tens of hours working on
this bug with Alan.  We'd appreciate the ability to stay in the loop
with any technical issues pertaining to and arising from the patch,
and to have our concerns properly responded to.

-Leonid


On Thu, May 29, 2008 at 2:48 PM, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 29 May 2008, Greg KH wrote:
>>       USB: EHCI: fix performance regression
>
> That's not a regresssion at all!  Plus, this patch shouldn't
> have included the timeout change.  The timeout change is why
> I didn't ACK this patch...
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
