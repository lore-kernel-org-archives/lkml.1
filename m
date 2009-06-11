Return-Path: <linux-kernel-owner+w=401wt.eu-S1761887AbZFKQlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887AbZFKQlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZFKQlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:41:13 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57568 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZFKQlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:41:12 -0400
Date: Thu, 11 Jun 2009 17:41:11 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/5][V2] FS: userspace notification of errors
Message-ID: <20090611164111.GC12367@shareable.org>
References: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com> <ac3eb2510906110626i165aadf0ma57f320e7e8a2356@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510906110626i165aadf0ma57f320e7e8a2356@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> No, the objection was to use the underlying *device* as the source to
> raise filesystem events. I don't think there are problems in general
> with objects in /sys/fs/ sending events.
> 
> But, the remaining questions here are:
> Do we really want superblocks exported in the global,
> non-namespace-aware /sys? It might be wrong to export stuff from other
> namespaces for filesytems which are irrelevant, and not even visible.
> I'm not sure about this, and it needs careful evaluation. We once had
> filesystem mount/umount uevents on block devices, and we needed to
> remove them for that namespace reason.

Is there no namespace awareness in /sys?

So how do namespaced guests deal with not having access to /sys, given
modern distros make extensive use of it?

-- Jamie
