Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYCIAyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYCIAyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 19:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYCIAyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 19:54:06 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:22250 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYCIAyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 19:54:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UTuhNdQAaCaU6aPeacp1kFVYH4uWlJs4TrPWE0KgmhD9Q/9IL7H1P+NdiBNqBBwfRc7CFL/FAoaOVe3lp1Zz4XD7gXEdzarS2+M4wAcNOc+4K0jpZwTtser/HIYYj5o4nFii9a92wdYqQAH53PDDu/PD8N7D1OqnAcGC3HlP8xY=
Message-ID: <a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
Date: Sun, 9 Mar 2008 08:54:02 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH v2] add time_now_after and other macros which compare with jiffies
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <877igd6vqn.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803080735.06984.hidave.darkstar@gmail.com>
	 <877igd6vqn.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2008 at 12:12 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi Dave, Andrew and all
>
>
>  Dave Young <hidave.darkstar@gmail.com> writes:
>
>  > +/* time_now_after(a) return true if now (jiffies) is after a */
>  > +#define time_now_after(a) time_after(jiffies, a)
>  > +
>  > +/* time_now_before(a) return true if now (jiffies) is before a */
>  > +#define time_now_before(a) time_before(jiffies, a)
>  > +
>  > +/* time_now_after_eq(a) return true if now (jiffies) is after or equal to a */
>  > +#define time_now_after_eq(a) time_after_eq(jiffies, a)
>  > +
>  > +/* time_now_before_eq(a) return true if now (jiffies) is before or equal to a */
>  > +#define time_now_before_eq(a) time_before_eq(jiffies, a)
>
>  How about even more obvious names like time_is_past(), time_is_future(),
>  ...?

Thanks for comment.

Then how do we name the _eq version?  IMHO, the time_now_* is enough.

>
>  Sorry, I missed v1.  Should have proposed that earlier.
>
>         Hannes
>

Regards
dave
