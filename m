Return-Path: <linux-kernel-owner+w=401wt.eu-S1763196AbYALKVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763196AbYALKVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 05:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbYALKVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 05:21:44 -0500
Received: from [212.12.190.41] ([212.12.190.41]:33714 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752379AbYALKVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 05:21:43 -0500
From: Al Boldi <a1426z@gawab.com>
To: 7eggert@gmx.de
Subject: Re: [RFD] Incremental fsck
Date: Sat, 12 Jan 2008 13:20:53 +0300
User-Agent: KMail/1.5
References: <9JubJ-5mo-57@gated-at.bofh.it> <9JHLl-2dL-1@gated-at.bofh.it> <E1JDKkM-0003dY-1b@be1.7eggert.dyndns.org>
In-Reply-To: <E1JDKkM-0003dY-1b@be1.7eggert.dyndns.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801121320.53882.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > Even after a black-out shutdown, the corruption is pretty minimal, using
> > ext3fs at least.  So let's take advantage of this fact and do an
> > optimistic fsck, to assure integrity per-dir, and assume no external
> > corruption.  Then we release this checked dir to the wild (optionally
> > ro), and check the next. Once we find external inconsistencies we either
> > fix it unconditionally, based on some preconfigured actions, or present
> > the user with options.
>
> Maybe we can know the changes that need to be done in order to fix the
> filesystem. Let's record this information in - eh - let's call it a
> journal!

Don't mistake data=journal as an fsck replacement.


Thanks!

--
Al

