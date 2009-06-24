Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZFXRCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZFXRCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZFXRCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:02:22 -0400
Received: from mail-yx0-f194.google.com ([209.85.210.194]:53612 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZFXRCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fwEFbM1v7h3738uIyLm0b9dCc5G8ir5iKCmlwMHE5npKnU2pdAR+agdub2rjfL9myt
         gJXxJ9qCG+1iYI8dz2GIZ5h8An2gwEeBBqhyDeBlAi2+8EamxSdbm8gGPKr2s2dmRHRG
         vGUoXFNRHvRfMJXGp14npNGFzOz2CWGW9ePtc=
MIME-Version: 1.0
In-Reply-To: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu>
References: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 24 Jun 2009 10:02:04 -0700
Message-ID: <a36005b50906241002g7a116d17n52e6af2ff9891f87@mail.gmail.com>
Subject: Re: [RFC] O_NOACC: open without any access
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 23:55, Miklos Szeredi<miklos@szeredi.hu> wrote:
> The sole purpose is to help race free "userspace lookup" type
> operations.  So fstat, fch*, *at work but nothing else.  Filesystem's
> ->open() is not called and f_op is set to NULL.

Before adding something like this, please look at the 2009 POSIX spec.
 There are two new open() flags which have to be implemented: O_EXEC
and O_SEARCH.  These might already suffice for what you want.
