Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbYASEIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbYASEIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbYASEIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:08:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:7823 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760385AbYASEIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YrhHDQGItGcPGicF5gbLTmZ1jdlT8uJ8o0HIgpmmB9l4sxmDsvW1sREGGabbvsh86jDDQeaxfCqWAvOqdQauFqqX1L6La47Hy8qHG9NTV6JrKZpRSp0dzjZchajANf+rFJ30MldEBr506aJxHyHKWe6x6CGi23+hR8EyV/xCP18=
Message-ID: <479177BC.8030200@gmail.com>
Date: Sat, 19 Jan 2008 13:08:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Ash Willis <ashwillis@programmer.net>,
       linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
References: <200801190722.26154.rusty@rustcorp.com.au> <47915515.1020905@gmail.com> <47915614.7080608@gmail.com> <200801191459.49735.rusty@rustcorp.com.au>
In-Reply-To: <200801191459.49735.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rusty Russell wrote:
>     There are three possibilities: (1) force everyone to use void *, (2) force 
> everyone to be type-correct, (3) allow both with some tricks.  Currently 
> we're on (1).  For kthread, with only dozens of users, I chose (2) (very 
> simple, easy to understand).  I think for widespread things like timer and 
> interrupt handlers, I think (3) is the right way to go.

Yeah, during transition, we definitely want (3).

>     I wanted to get this patch out there and see what the reaction was.  I can 
> do timers next, if that's going to add fuel to the discussion.

I think you successfully got a very small sample of possible reactions.
 Jeff vetoing it (and for good reasons) and me a bit more positive but
not quite sold.  Yeah, I think we need a good flame war to determine our
heading and converting timer shouldn't take too much of your time, right?

Thanks.

-- 
tejun
