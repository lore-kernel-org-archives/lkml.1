Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXJXHoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXJXHoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXJXHoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:44:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:3939 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbXJXHoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DTXj6/dFcwCxyJ6W9Nrr9C09DrZffgKygX9x4LxKQllfVbPJVVXzxT0xv37HRoysiNzlfJ5PfLNndN4uRE6SkLsLlI4qGPEIRtR7QgZLFjZ8TEscBjTN8/uIfUQmC6rUhvEmXtOAzYo/yn3VPY5ihzZrGW/+UeUzZ1e/0BFOPLQ=
Message-ID: <471EF7C7.6020708@gmail.com>
Date: Wed, 24 Oct 2007 09:44:07 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/12] riscom8: fix SMP brokenness
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>	<20071023223638.DD9FE1F81A8@havoc.gtf.org>	<471EEA7B.8070008@gmail.com> <20071024001052.4290adc7.akpm@linux-foundation.org>
In-Reply-To: <20071024001052.4290adc7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2007 09:10 AM, Andrew Morton wrote:
> On Wed, 24 Oct 2007 08:47:23 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>>> +static spinlock_t riscom_lock = SPIN_LOCK_UNLOCKED;
>> This is deprecated (see linux/spinlock_types.h for details), use DEFINE_SPINLOCK
>> instead, otherwise seems OK.
> 
> Hey, if only we had a little perl script to check stuff like that.

Can we integrate this into checkpatch?
