Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbZFXSGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbZFXSGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZFXSGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:06:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34638 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZFXSGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:06:16 -0400
To: drepper@gmail.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
In-reply-to: <a36005b50906241002g7a116d17n52e6af2ff9891f87@mail.gmail.com>
	(message from Ulrich Drepper on Wed, 24 Jun 2009 10:02:04 -0700)
Subject: Re: [RFC] O_NOACC: open without any access
References: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <a36005b50906241002g7a116d17n52e6af2ff9891f87@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1MJWrI-0002Bm-Bk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Jun 2009 20:06:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Ulrich Drepper wrote:
> On Wed, Jun 17, 2009 at 23:55, Miklos Szeredi<miklos@szeredi.hu> wrote:
> > The sole purpose is to help race free "userspace lookup" type
> > operations.  So fstat, fch*, *at work but nothing else.  Filesystem's
> > ->open() is not called and f_op is set to NULL.
> 
> Before adding something like this, please look at the 2009 POSIX spec.

Is it available online somewhere?  If not, could you please post the
relevant parts?

>  There are two new open() flags which have to be implemented: O_EXEC
> and O_SEARCH.  These might already suffice for what you want.

I suspect they are not quite what we want (both of them requring
MAY_EXEC on file, no?)

Thanks,
Miklos
