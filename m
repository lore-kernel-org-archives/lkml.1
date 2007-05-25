Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXEYLmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXEYLmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXEYLml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:42:41 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3193 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075AbXEYLmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:42:40 -0400
Date: Fri, 25 May 2007 13:43:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] tty_io: Use kzalloc
Message-ID: <20070525134344.0f93e797@hyperion.delvare>
In-Reply-To: <84144f020705250345x4faa23f7kc6276017285357e8@mail.gmail.com>
References: <20070525124258.5b72f077@hyperion.delvare>
	<84144f020705250345x4faa23f7kc6276017285357e8@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 13:45:58 +0300, Pekka Enberg wrote:
> Hi Jean,
> 
> On 5/25/07, Jean Delvare <khali@linux-fr.org> wrote:
> > -               ltp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
> > +               ltp = (struct ktermios *) kzalloc(sizeof(struct ktermios),
> >                                                  GFP_KERNEL);
> 
> When doing conversions like this, please drop the redundant casts too.

Good point, sorry for overlooking this. Updated patch follows.

-- 
Jean Delvare
