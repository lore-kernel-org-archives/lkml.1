Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbYD1Jn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbYD1Jn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbYD1JnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:43:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:62289 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbYD1JnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=S+vpV5VEFT5ot2CXkCs1bO37PbwFs/aywJkRiZUsy9X1Jza5kTawFWXXgmJa+HvzFziYD9aXuftMZv7TYDraFkv+J87Sfc5DaBAA/GIZa2Bj4xZ3IcpFhm9exLGhuiTKlapc8rmUIB3Ft7Yhuuy8DRaQBhg86V4yxYWe13y/vME=
Message-ID: <517f3f820804280243q4a4bb9dbv27ce4be90fdd5954@mail.gmail.com>
Date: Mon, 28 Apr 2008 11:43:11 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: [PATCH] dup2 w/flags
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org,
       "Michael Kerrisk" <mtk.manpages@gmail.com>
In-Reply-To: <200804280320.m3S3KSFu028466@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804280320.m3S3KSFu028466@devserv.devel.redhat.com>
X-Google-Sender-Auth: fa06f24b20e45402
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/08, Ulrich Drepper <drepper@redhat.com> wrote:
> This patch adds dup3 which is dup2 with an additional parameter.  The
>  parameter takes the usual O_* flags, with only O_CLOEXEC handled so far
>  (it's possible to handle O_NONBLOCK in future, if this is wanted).
>
>  I've read some people mentioning that we simply should use a new fcntl()
>  extension similar to F_DUPFD_CLOEXEC.  I think that's a terrible idea
>  and in any case not better than sys_indirect.  A new syscall is the
>  cleanest solution and it's really only a little bit of effort.

Ulrich,

To repeat my earlier request, and as requested in Documentation/HOWTO,
could you please CC me on API changes.  This alerts me to what may
eventually need documenting in man-pages.

Cheers,

Michael
