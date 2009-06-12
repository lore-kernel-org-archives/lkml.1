Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbZFLWma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbZFLWma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZFLWmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:42:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63153 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbZFLWmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:42:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=aSzdxSmiQJhGvosX0Zd0qsJFWk2J0ODPjE+O49fYMWxbITNEy71J8uUo8XnHtmEv6
	W+GvIY1VAiARr0MTnUKbw==
MIME-Version: 1.0
In-Reply-To: <1cc472780906121538h5b70fa4dg891ff729fda1a566@mail.gmail.com>
References: <a55d774e0906121450x12bab7b0sc1f4de0115a1af61@mail.gmail.com>
	 <20090612222229.GE17688@elf.ucw.cz>
	 <1cc472780906121538h5b70fa4dg891ff729fda1a566@mail.gmail.com>
Date: Fri, 12 Jun 2009 15:42:21 -0700
Message-ID: <a55d774e0906121542g182d4814udd66c2d1ebf57cf5@mail.gmail.com>
Subject: Re: Gerrit (was Re: HTC Dream aka. t-mobile g1 support)
From: Brian Swetland <swetland@google.com>
To: Shawn Pearce <sop@google.com>
Cc: Pavel Machek <pavel@ucw.cz>, Stefan Schmidt <stefan@datenfreihafen.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, Chris Dibona <cdibona@google.com>,
       Daniel Berlin <dannyb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 3:38 PM, Shawn Pearce<sop@google.com> wrote:
> On Fri, Jun 12, 2009 at 15:22, Pavel Machek <pavel@ucw.cz> wrote:
>> On Fri 2009-06-12 14:50:21, Brian Swetland wrote:
>> > Gerrit is a git patch review system that we (Google/Android) use for
>>
>> Unfortunately, it seems quite unsuitable for kernel.
>>
>> Do I understand it right that to submit kernel patches I'd have to
>> agree to "contributors agreement", and give up my copyright? No,
>> sorry, I don't think I want to do that.
>
> No.  The contributor agreement used by review.source.android.com is a stronger version of the Developers Certificate of Origin normally used by kernel
> contributors.
> For the actual agreement text see[1], but the basic principle is the same.
>  No assignment of copyright, only assignment of license for redistribution,
> which is what the GPL asks anyway.  It also contains a patent provision,
> similar to what the Apache License contains, to protect the project leads
> from submarine patent infringement by code contributed by a patent holder.
> [1] https://review.source.android.com/static/cla_individual.html

When we first discussed the CLA, I raised this concern (that the
mainline kernel folks would not be thrilled by another system in
addition to Signed-off-by), and was informed that we should not have
to require CLA acceptance for contributions to the kernel/... trees.
I'm not sure if Gerrit is setup to handle this yet.

We will always happily accept kernel patches via email/mailinglist,
per the standard linux kernel development model.

Brian
