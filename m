Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXGMC0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXGMC0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 22:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXGMCZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 22:25:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:35132 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbXGMCZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 22:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oTnBf6ivUkwbpRAJdew1QutgdTU0BZr+xMv43kAQZQQ/hIWku1/9htR5QR0cv40ZGS7JPoML1q+cSQ5HI42DLxLkVh7jViLmMikydB5dADKDomoddz00uRK8dsPZ/d5Jrmit6Q+9vOlU6vhddKvjobryXV444crIoBjNLubmJ/g=
Message-ID: <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com>
Date: Fri, 13 Jul 2007 04:25:56 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Ray Lee" <ray-lk@madrabbit.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>
In-Reply-To: <4696C89E.4010002@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707111916.35036.jesper.juhl@gmail.com>
	 <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com>
	 <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com>
	 <4696C89E.4010002@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/07/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Jesper Juhl wrote:
> > If, on the other hand, we consider 4K stacks to be the superior
> > solution, then we should work to get all code fixed to be able to
> > handle it so that it's actually something distros will start to enable
> > so that we can eventually get rid of the 8K stack option alltogether.
> > Making 4K stacks default and no longer a debug option is just the
> > first step in that direction.
>
> First step is to apply wli's patch which makes separate interrupt stacks
> orthogonal to the 4K stack option.
>
Yes and no.  If that will get things moving in the direction of
getting rid of the stack size as a config option, then I'm all for it.
But on the other hand it is my personal opinion that this is an area
where we should just make up our minds as to whether we want 4K or 8K
stacks and whether we want interrupt stacks or not, and then not have
it configurable at all.  I believe the goal is 4K stacks + interrupt
stacks, so let's just aim for that and get rid of the configurability
of the damn thing - make a choice, make it work, make it be that
that's what we use and rid ourselves of the alternatives...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
