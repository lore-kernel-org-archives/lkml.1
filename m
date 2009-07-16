Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbZGPQem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbZGPQem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbZGPQel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:34:41 -0400
Received: from nox.protox.org ([88.191.38.29]:40710 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732AbZGPQel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:34:41 -0400
Subject: Re: [PATCH] ttm: add pool wc/uc page allocator
From: Jerome Glisse <glisse@freedesktop.org>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>
In-Reply-To: <1247760821-12122-1-git-send-email-jglisse@redhat.com>
References: <1247760821-12122-1-git-send-email-jglisse@redhat.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 18:34:35 +0200
Message-Id: <1247762075.12808.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 18:13 +0200, Jerome Glisse wrote:
> On AGP system we might allocate/free routinely uncached or wc memory,
> changing page from cached (wb) to uc or wc is very expensive and involves
> a lot of flushing. To improve performance this allocator use a pool
> of uc,wc pages.
> 
> Currently each pool (wc, uc) is 256 pages big, improvement would be
> to tweak this according to memory pressure so we can give back memory
> to system.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>

Just a follow-up on that one, i haven't been able yet to thoroughly
test this patch on AGP system, so i am mostly sending so other people
can test. I think i corrected few bugs that were in previous iteration
of that patch.

Beside that i think i have addressed all comment previously raisen,
but don't hesitate to pin point any things i have miss.

Cheers,
Jerome

