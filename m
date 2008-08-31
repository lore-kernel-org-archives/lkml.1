Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYHaMXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYHaMXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 08:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758342AbYHaMX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 08:23:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60311 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338AbYHaMX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 08:23:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Date: Sun, 31 Aug 2008 14:27:18 +0200
User-Agent: KMail/1.9.9
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <200808302334.29156.rjw@sisk.pl> <86802c440808301810r17657f3fnb3c8af5496955e0d@mail.gmail.com>
In-Reply-To: <86802c440808301810r17657f3fnb3c8af5496955e0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311427.19369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 31 of August 2008, Yinghai Lu wrote:
> On Sat, Aug 30, 2008 at 2:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, 30 of August 2008, Yinghai Lu wrote:
> >> On Sat, Aug 30, 2008 at 2:12 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >> > On Sat, Aug 30, 2008 at 1:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >> On Saturday, 30 of August 2008, Yinghai Lu wrote:
> >> >>> please check
> >> >>>
> >> >>> [PATCH] x86: split e820 reserved entries record to late v4
> >> >>> [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
> >> >>
> >> >> What kernel should I apply those to and in what order?
> >> >
> >> > linus git tree
> >> > 1. [PATCH] x86: split e820 reserved entries record to late v4
> >> > 2. [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
> >> >
> >> > tip/master
> >> > 1. Resource handling: add 'insert_resource_expand_to_fit()' function
> >> > 2. [PATCH] x86: split e820 reserved entries record to late v4 - fix v6
> >>
> >> actually it is almost the same to tar ball send you for your system...
> >
> > I've just tested these two patches on top of the current Linus' tree and the
> > system works normally.
> >
> 
> Can you try attached in addition to those to patches ?
> 
> want to check if the BAR3 get new resource..., and after that what
> could happen...

Works, dmesg is at:
http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/2.6.27-rc5-test.log

Please let me know if you want it with any more command line options.

Thanks,
Rafael
