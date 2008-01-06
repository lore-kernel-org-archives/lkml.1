Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYAFK6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYAFK6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 05:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYAFK6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 05:58:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:19970 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYAFK6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 05:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Oh13uF0xQbcJNoZvZKVbbI36pbsXTCtkE9Q/esr3iFNj0nxjA006oyFxRW/rRG7HnryahbGyLu59hu3KJ6uGsSv2HT3YWqtbBOSU6O9DVjvb3ovuknFlgMqBx3IIPcFOPLx5MrmDKmK5AkgSZo0JfnKKzsznsoKjAm9it43Lzcs=
Message-ID: <4d8e3fd30801060258t7b5bde72q37a2f402fc378450@mail.gmail.com>
Date: Sun, 6 Jan 2008 11:58:21 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] profile: further Codying Style fixes
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080106102544.GB11765@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104152858.1fb9b868@paolo-desktop>
	 <20080106102544.GB11765@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 6, 2008 11:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> > Further codying style fixes on top of:
> > http://marc.info/?l=linux-kernel&m=119940325306693&w=2
>
> thanks, applied.

Hi Ingo,
I posted a new version of that patch:
http://lkml.org/lkml/2008/1/4/197
It's in your inbox with subject:
[PATCH] profile: further Codying Style fixes, take 2

The patch you applied was changing the funtionality in case of
non-SMP build.
This was reported by Sam Ravnborg , see:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-01/msg01383.html

Can you please apply the new patch?

> > 1 Warning is still not killed:
> > WARNING: externs should be avoided in .c files
> > #509: FILE: profile.c:509:
> > +       extern int setup_profiling_timer(unsigned int multiplier);
> >
> > I don't know how to fix it :-/
>
> simply move that line to include/linux/profile.h. (no need to preserve
> the CONFIG_SMP - on !SMP the function prototype line will not be used)

Thanks.


Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
