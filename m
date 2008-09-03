Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYICIhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYICIhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYICIhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:37:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:42801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYICIhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:37:42 -0400
Subject: Re: [2.6.27] early exception - lockdep related?
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <68676e00809030128o45820023n6f270847e14af2a3@mail.gmail.com>
References: <20080902210646.GA10925@dreamland.darkstar.lan>
	 <1220424721.8609.74.camel@twins>
	 <68676e00809030128o45820023n6f270847e14af2a3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 10:37:41 +0200
Message-Id: <1220431061.8609.87.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 10:28 +0200, Luca Tettamanti wrote:
> On Wed, Sep 3, 2008 at 8:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2008-09-02 at 23:06 +0200, Luca Tettamanti wrote:
> >> Hello,
> >> I'm seeing an early exception (0e) - which seems related to lockdep - at
> >> boot with many 2.6.27 kernels and I'm having troubles to track it down.
> >
> > Does it print one of these nice stack traces?
> 
> Of course not ;-) It dies before dumping the stack trace (or at least
> it doesn't make to the console - that machine has a serial port, but
> my notebook does not... I've ordered a usb-to-serial adapter).

Until it arrives, you could try poking at netconsole.. 

> >> The strange thing is that it comes and goes with different kernel
> >> versions
> >
> > What kernel version did you generate the below with - and what config.
> 
> -rc2 is working, after that it's intermittent. The last kernel that I
> tried is -git from a couple of days ago.

OK, once you send you .config, I'll try and reproduce on one of my
machine. Perhaps you can also provide the git-describe output of a known
bad one.

> >> , but a "bad" kernel consistently fails across reboots. It also
> >> seems to be sensitive to the configuration (attached)
> >
> > you seem to have forgotten that attachment.
> 
> Ops, will send as soon as I get home.

Sure thing..

