Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbYHMQDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbYHMQDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYHMQDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:03:41 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:19303 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbYHMQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d1Az0B9AACnhep1BhsOA5TBTGi6/aByx4XK62atq6+Y582ue4KnI6vkvqKKDjjwChh
         ttAxiGfyWN7jBB7AVTU6jFm0bGgR5ng83BHNgo15Lt/PGeJRrZfMJWmDCx/7zJ1b/s+Q
         XTMAuTKS6HsRCjJisE7vPEvWlVMbrtTL4omlI=
Message-ID: <86802c440808130903u3ff76babtfb8903a970a65768@mail.gmail.com>
Date: Wed, 13 Aug 2008 09:03:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- experimental revert for 2.6.27 failed
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <108777.49875.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <108777.49875.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 5:03 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> please try attached patch with 2.6.27-rc3
>
> Thx for the patch... and for providing it as an attachment.  My email
> situation is less than optimal, and I am stuck using my ISP's web
> interface for the present.
>
> I used 'git apply --check <patchfilename>' first, and got no errors, so
> I applied it, built, installed, and rebooted.

that patch revert to use request_resource, so there is some other problem

YH
