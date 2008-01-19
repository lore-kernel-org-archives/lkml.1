Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYASX2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYASX2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYASX2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:28:30 -0500
Received: from ozlabs.org ([203.10.76.45]:45403 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYASX23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:28:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
Date: Sun, 20 Jan 2008 10:27:48 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Ash Willis <ashwillis@programmer.net>,
       linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org
References: <200801190722.26154.rusty@rustcorp.com.au> <200801191459.49735.rusty@rustcorp.com.au> <479177BC.8030200@gmail.com>
In-Reply-To: <479177BC.8030200@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200801201027.49223.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 15:08:28 Tejun Heo wrote:
> Rusty Russell wrote:
> >     There are three possibilities: (1) force everyone to use void *, (2)
> > force everyone to be type-correct, (3) allow both with some tricks. 
> > Currently we're on (1).  For kthread, with only dozens of users, I chose
> > (2) (very simple, easy to understand).  I think for widespread things
> > like timer and interrupt handlers, I think (3) is the right way to go.
>
> Yeah, during transition, we definitely want (3).

Hi Tejun.

    I'm thinking an open-ended transition.  I don't see a big reason to churn 
working code, since we can easily support both.

> Yeah, I think we need a good flame war to determine our
> heading and converting timer shouldn't take too much of your time, right?

   Insightful comment, you've convinced me!

Thanks,
Rusty.
