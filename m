Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbXLFUCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbXLFUCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXLFUB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:01:58 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:30081 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXLFUB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:01:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Zg/h3ZiUelRfh0G2G0jMxoXVdO+fsNhTTlXHKA+V3ICVxMd94wGMc8wGX1aJczjclpccr6zCffo+o4gcD1rT/rwqS2SXs7UbIHypM0bWc+wGECqMcTWsdj+fNGgukEXKbCbzYEOWKLWh/x8YqBUqfHEFkrPs+PdaOs92H9hVVik=
Message-ID: <3efb10970712061201l343ad865mae920c3e6d43bfd9@mail.gmail.com>
Date: Thu, 6 Dec 2007 21:01:54 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071206021857.826386004@mvista.com>
	 <20071206021909.131993721@mvista.com> <20071206102334.GE17299@elte.hu>
	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
X-Google-Sender-Auth: a85730edb2a74c1f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

FYI: I am working on the conversion of the 2 sem->mutex in kernel/printk.c

Remy

2007/12/6, Daniel Walker <dwalker@mvista.com>:
> On Thu, 2007-12-06 at 11:23 +0100, Ingo Molnar wrote:
> > * Daniel Walker <dwalker@mvista.com> wrote:
> >
> > > The port_mutex is actually a semaphore, so easily converted to a
> > > struct mutex.
> > >
> > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> >
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> >
> > cool. How far away are we from being able to remove all the semaphore
> > code? :-)
>
> I wish my 7 patches made a dent, but it's hasn't done much. ;(
>
> I would guess at least a week just to mop up the relatively easy ones..
> I've got 12 in my queue, and there still ~50 hopefully trivial ones
> still to be looked at.. Then another ~30 more difficult ones (that use
> init_MUTEX_LOCKED, or sema_init with 0 instead of 1) ..
>
> Daniel
>
>
