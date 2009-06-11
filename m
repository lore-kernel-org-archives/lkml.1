Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbZFKQoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbZFKQoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbZFKQoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:44:01 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63184 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZFKQoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <20090611164111.GC12367@shareable.org>
References: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com> 
	<ac3eb2510906110626i165aadf0ma57f320e7e8a2356@mail.gmail.com> 
	<20090611164111.GC12367@shareable.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 11 Jun 2009 18:43:46 +0200
Message-ID: <ac3eb2510906110943r4af7a1baue3a8e6bc12b16f2d@mail.gmail.com>
Subject: Re: [PATCH 0/5][V2] FS: userspace notification of errors
To: Jamie Lokier <jamie@shareable.org>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 18:41, Jamie Lokier<jamie@shareable.org> wrote:
> Kay Sievers wrote:
>> No, the objection was to use the underlying *device* as the source to
>> raise filesystem events. I don't think there are problems in general
>> with objects in /sys/fs/ sending events.
>>
>> But, the remaining questions here are:
>> Do we really want superblocks exported in the global,
>> non-namespace-aware /sys? It might be wrong to export stuff from other
>> namespaces for filesytems which are irrelevant, and not even visible.
>> I'm not sure about this, and it needs careful evaluation. We once had
>> filesystem mount/umount uevents on block devices, and we needed to
>> remove them for that namespace reason.
>
> Is there no namespace awareness in /sys?

No, not at all. It is the straight export of the core kernel objects.

> So how do namespaced guests deal with not having access to /sys, given
> modern distros make extensive use of it?

They ignore it and don't use it, or get confused, I guess. :)

Thanks,
Kay
