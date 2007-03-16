Return-Path: <linux-kernel-owner+w=401wt.eu-S965851AbXCPSzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851AbXCPSzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965864AbXCPSzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:55:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:12412 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965851AbXCPSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oI2DyaQQU49jHK87+PE56folqm+UM6alfwtPL2VNugpLU9lEX78j4nTbDGxMxlRIVQA+4/tKj8FcC092wZA+d8KQK9YV7RHnA91twXCY5sedO15F6aPJWfQWgahLNDItzWegvyDeJgzQjlxTUpHH6uP6hlSlPj37cJs8dTZl5Bs=
Message-ID: <6bffcb0e0703161155o1e153725jd3f4a01fb5fa0d55@mail.gmail.com>
Date: Fri, 16 Mar 2007 19:55:35 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Takashi Iwai" <tiwai@suse.de>
In-Reply-To: <20070316102650.267e2c55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <45FAD77A.1070709@googlemail.com>
	 <20070316102650.267e2c55.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 16 Mar 2007 18:44:26 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > I've got *bad* news. Bug described here
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#0889
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
> > probably leaked into mainline.
> >
> > Fsck!
>
> fsck indeed.  I don't even understand what's happening with that one - it
> seems like the kernel schedules a user process, but never deschedules it
> again.
>

Tomorrow, I'll try to find out how to reproduce this bug.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
