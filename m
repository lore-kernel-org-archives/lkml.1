Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbXEPSxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbXEPSxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbXEPSxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:53:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:48665 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbXEPSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W0hFfcP5YaY+8Xev0r6d7lzRokkqLZ/v7z2VDODHCWqGblmXrNd6CssZYGOtC8j7VGo153G8ZOsJ660DbIvPRcsvmhF0ebpjuGOpIyWEACcfmAw5JJaihXkacQN2CL600Nv2Ehj3dwpBu+AQQq3S1M15Mkrk6UEk92kK82Qw1Jk=
Message-ID: <29495f1d0705161152q258802aw6a2b49f5f9e0d385@mail.gmail.com>
Date: Wed, 16 May 2007 11:52:59 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: 2.6.22-rc1-mm1: boot failure under qemu
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <464B4C68.6080804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464ABF7C.1000307@goop.org> <464B2762.7040508@zytor.com>
	 <464B318F.1060309@goop.org> <464B4687.20901@zytor.com>
	 <464B4C68.6080804@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> H. Peter Anvin wrote:
> > Okay, I've established that this is a bug in the Qemu kernel loader: the
> > Qemu loader puts zero in the loadflags, which is wrong no matter how you
> > slice it.
> >
> > I have checked in a workaround in the git.newsetup tree; the workaround
> > is to rely on a compile-time value for load low/load high instead of
> > looking at loadflags.
> >
>
> Can you post a patch to try?

You can snag it from gitweb:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=commit;h=a1608be536b7e60362923c5bdc9f3ab3ddd27ee5

The patch itself:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=commitdiff;h=a1608be536b7e60362923c5bdc9f3ab3ddd27ee5;hp=92d07d79f86a778f253001a7cf0758b49f39eb77

Thanks,
Nish
