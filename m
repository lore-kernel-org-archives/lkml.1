Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbYBCNiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbYBCNiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 08:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYBCNiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 08:38:09 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:48686 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYBCNiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 08:38:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CBBNPLdbz8ywsNV3SiEYPs4rauTHgQPtH1JxDvaVGjon1zCTodzaZS/RW4huHlzRm4TD1/WM8DG4xs6YhEtBaQjUGEaxh5d3dzN1x9UJA76QfGpJg+ZiT/QtanURptkJW+WtZ7DRbuZSz3oqwdJJErgfxYZGkwbjAl53u+EUZGc=
Message-ID: <2f11576a0802030538j4ad57469g22a04a7cb54bdcd1@mail.gmail.com>
Date: Sun, 3 Feb 2008 22:38:04 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Jon Masters" <jonathan@jonmasters.org>
Subject: Re: Kernel Event Notifications (was: [RFC] Parallelize IO for e2fsck)
Cc: "Al Boldi" <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <1201562634.5412.70.camel@jcmlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <20080124234037.GJ15858@mit.edu>
	 <2f11576a0801260432y4405d817p6ef4005d06189654@mail.gmail.com>
	 <200801261655.31313.a1426z@gawab.com>
	 <1201562634.5412.70.camel@jcmlaptop>
X-Google-Sender-Auth: d9ff1d67e478beb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon

> I looked at this a year or two back, then ran out of time. But the thing
> I wanted to do was have libc's memory allocation routines extended to
> handle these through reservations - the kernel should send a userspace
> notification and then there should be some kind of concept of returning
> memory that's been used for "opportunistic" userspace caching, e.g. in
> firefox to cache the last 10 web pages. Let us know how you get on :)

sorry for late response.
(I didn't notice your mail ;-)

You are right...
stupid user space caching is very important problem.

but I think this is no libc problem.
glibc malloc hardly caches the memory.
(its default behavior only caching 128K.)

but some application use large memory for too opportunistic caching.
I understood we need propagandize that using mem_notify to application guys
after it merge mainline.

I have no idea of solve it easily.
