Return-Path: <linux-kernel-owner+w=401wt.eu-S1764411AbYASEA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764411AbYASEA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761667AbYASEAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:00:22 -0500
Received: from ozlabs.org ([203.10.76.45]:46944 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687AbYASEAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:00:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
Date: Sat, 19 Jan 2008 14:59:49 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Ash Willis <ashwillis@programmer.net>,
       linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org
References: <200801190722.26154.rusty@rustcorp.com.au> <47915515.1020905@gmail.com> <47915614.7080608@gmail.com>
In-Reply-To: <47915614.7080608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801191459.49735.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 12:44:52 Tejun Heo wrote:
> Tejun Heo wrote:
> > so I think the question is "do we want to change all callbacks to
> > take native pointer type instead of void pointer?".
>
> Lemme clarity myself a bit.  I'm not saying that we should convert all
> at once or literally every callback should be converted.  What I'm
> saying is whether we're headed that way in general and converting big
> ones - timer for example - and getting the conversion agreed upon should
> be enough to set the norm.

Hi Tejun

    There are three possibilities: (1) force everyone to use void *, (2) force 
everyone to be type-correct, (3) allow both with some tricks.  Currently 
we're on (1).  For kthread, with only dozens of users, I chose (2) (very 
simple, easy to understand).  I think for widespread things like timer and 
interrupt handlers, I think (3) is the right way to go.

    I wanted to get this patch out there and see what the reaction was.  I can 
do timers next, if that's going to add fuel to the discussion.

Thanks!
Rusty.
