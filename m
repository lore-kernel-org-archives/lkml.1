Return-Path: <linux-kernel-owner+w=401wt.eu-S1767278AbXDEUNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767278AbXDEUNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767282AbXDEUNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:13:54 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50346 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767278AbXDEUNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:13:53 -0400
Date: Thu, 5 Apr 2007 13:06:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 6/8] Make non-singlethreaded workqueues freezeable by
 default
Message-Id: <20070405130640.099d7fac.akpm@linux-foundation.org>
In-Reply-To: <20070405115714.GA755@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com>
	<20070402054107.GF12962@in.ibm.com>
	<20070405115714.GA755@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 15:57:14 +0400
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 04/02, Gautham R Shenoy wrote:
> >
> > +extern struct workqueue_struct *create_freeze_exempted_workqueue(const char *name, int freeze_exempt_events);
> > +
> > +extern struct workqueue_struct *create_singlethread_workqueue(const char *name);
> 
> I bet akpm will say something about 110-column declaration...

something.
