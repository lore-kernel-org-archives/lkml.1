Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbYBNWbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbYBNWbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbYBNWbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:31:05 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48237 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbYBNWbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:31:01 -0500
To: menage@google.com
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <6599ad830802141005i52236f7ak337ffffb915ea8ce@mail.gmail.com>
	(menage@google.com)
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
	 <6599ad830802140813n71b56dccud33e19642a0d7647@mail.gmail.com>
	 <E1JPhvt-0002qE-Da@pomaz-ex.szeredi.hu> <6599ad830802141005i52236f7ak337ffffb915ea8ce@mail.gmail.com>
Message-Id: <E1JPmbT-0003cd-Qb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Feb 2008 23:30:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Feb 14, 2008 at 9:31 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> >  I deliberately not used the MS_* flags, which is currently a messy mix
> >  of things with totally different meanings.
> >
> >  Does this solve all the issues?
> 
> We should add a size parameter either in the mount_params or as a
> final argument, for future extensibility.

OK, let's add it to mount_params then.

> And we might as well include MNT_READONLY in the API on the assumption
> that per-mount readonly will be available soon.

Right.  That patch-set should already have been merged into 2.6.25...

Miklos
