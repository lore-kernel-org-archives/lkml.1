Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbXFKKDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbXFKKDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 06:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764372AbXFKKC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 06:02:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:40912 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764360AbXFKKC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 06:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=F7QiU5QurWeNQJW4FXK7mO1riUgLmDmzWjmEZp1xQj4Ql5PPFBWWyBsEL2C/5GJZ75WftYPKuxkiBnvESaKDgG0VXL34AtiM7jME5pAN7Ma1hczH8yXY7xuQCa5osALoeIPJcDBtxU+laYZ7L6JYgaTxJLx1ayUoOLRw3XRt5EI=
Message-ID: <466D1DC5.7020503@gmail.com>
Date: Mon, 11 Jun 2007 19:02:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 2.6.22-rc4] sysfs: fix race conditions
References: <20070611050107.GJ29122@htj.dyndns.org> <466D1CAC.6060307@aladin.ro>
In-Reply-To: <466D1CAC.6060307@aladin.ro>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard-Gabriel Munteanu wrote:
> *This message was transferred with a trial version of CommuniGate(r) Pro*
> Tejun Heo wrote:
> 
>> This patchset contains three minimal backports of fixes in -mm.  With
>> all patches in the patchset and sysfs-races.patch applied, kernel
>> survived ~20 hours of stress test without any problem.
>>
> 
> Seriously, do you think adding a few sleeps fixes anything? It just
> makes it harder to happen, and even harder to debug, so this is no good.
> Race condition are fixed by proper locking, ordering and so on.
> 
> (No offence, this has to be the patch of the week. :) )

Dude, what are you smoking and can I get some?  The attached patch is to
trigger the race conditions more easily for verification.  Actual fixes
are in the three patches posted as reply to the head message.

-- 
tejun
