Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZK1KTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZK1KTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 05:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZK1KTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 05:19:10 -0500
Received: from smtp-out.google.com ([216.239.33.17]:14004 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZK1KTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 05:19:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=i2IZj5H/jj3texp14SZhQmTwHdFjAndgRwfbCWyfH56luw5MUCTQm1yMkaNdD+oQh
	Y1NiUMh8KkVoEfKmuJRug==
MIME-Version: 1.0
In-Reply-To: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
References: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
Date: Sat, 28 Nov 2009 02:19:09 -0800
Message-ID: <a55d774e0911280219s69729b54l544660aac4b2197@mail.gmail.com>
Subject: Re: [PATCH 0/2] staging/android fixes
From: Brian Swetland <swetland@google.com>
To: Corentin Chary <corentincj@iksaif.net>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@google.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Chih-Wei Huang <cwhuang@linux.org.tw>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 12:45 AM, Corentin Chary <corentincj@iksaif.net> wrote:
> Hi,
> Here is a patch to fix build for android specifics drivers.
>
> What we should do next to prevent them from being removed in 2.6.23 ?
>
> Is there any chance that all android stuff would be merged one day ?
> Actually, we got a working 2.6.32 kernel for android here (with wakelock, ashm, etc..):
> http://git.iksaif.net/?p=android-x86/kernel;a=shortlog;h=refs/heads/android-x86-backport

Arve's done a few revisions of the wakelock code with the linux-pm
list, and I know he's planning on trying to work through the remaining
issues (as I recall there was some discussion on read/write vs ioctl
interfaces to userspace) in the near future.

This really is the one piece that has the most impact on everything
else -- maintaining versions of the various platform hardware drivers
with and without wakelock support is messy.

I'm not sure if there are seriously issues with picking up ashmem or
logger.  They are relatively small, simple, and self-contained.  The
binder driver seemed to be much more contentious.

Brian
