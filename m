Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbXGaNHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbXGaNHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbXGaNHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:07:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:27262 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXGaNHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=e9X9xyfGOQJn8TwOjAzv8YZVbyvSibGQRm3x87H5XiRQQPQm9zdsdED768kVfF3rAs9pigkbiWaK1FOHdGSbJ8Jk25yKlMvKchA5rWJ69J0f74OIFZokft8S53p6BCZ1/DHksn5KSIKCqOm+HTnAHrLrGMi6CpqhnXW3HT6Hmf0=
Date: Tue, 31 Jul 2007 21:08:28 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes (take 4)
Message-ID: <20070731130828.GA6900@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070730113847.GA28404@kernel.sg> <20070731115016.GA6326@localhost.localdomain> <20070731141953.656f0f4a@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731141953.656f0f4a@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 02:19:53PM +0200, Cornelia Huck wrote:
>On Tue, 31 Jul 2007 19:50:16 +0800,
>WANG Cong <xiyou.wangcong@gmail.com> wrote:
>
>> On Mon, Jul 30, 2007 at 07:38:47PM +0800, Eugene Teo wrote:
>> >This patch fixes these warnings:
>> >
>> >fs/partitions/check.c: In function 'add_partition':
>> >fs/partitions/check.c:391: warning: ignoring return value of 'kobject_add',
>> >	declared with attribute warn_unused_result
>> >fs/partitions/check.c:394: warning: ignoring return value of
>> >	'sysfs_create_link', declared with attribute warn_unused_result
>> >fs/partitions/check.c:401: warning: ignoring return value of
>> >	'sysfs_create_file', declared with attribute warn_unused_result
>> >
>> >Got it right this time. Thanks Cornelia for help.
>> >
>> 
>> <snip>
>> 
>> This was already done some months ago, see this:
>> http://marc.info/?l=linux-mm-commits&m=117624330000536&w=2
>> 
>> I don't know why this work is duplicated.
>
>Ha, that may explain my feeling of deja vu...
>
>IIRC, Andrew dropped the patch from -mm due to clashes with other
>patches. Did you try to re-submit it?

I see. I knew there was another patch against these code.
I thought Andrew's tools can deal with this, but it seems the fact is not.
Managing patches is really a hard work.

And this patch looks OK for me, too. Thanks!

-- 
To do great work, you have to have a pure mind. You can think only about the
mathematics. Everything else is human weakness. Accepting prizes is showing
weakness.

