Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZLRRjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZLRRjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZLRRjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:39:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53574 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZLRRjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:39:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=MjDdG4cUGwyNjCadtuJDaCsBakuQiWkX9kgzY5dw8wEIQKSHnag4bo5F7RMYSxXD5W
         Z2K6bGZxdIH+qa7ZSm6qoHSYNjLGX5GeLmbhESl05Mf/UepznYQa1mWGNykmmNIdDsQG
         ZW7gbr023o2pmLMuYvb4hMxvJV28VMkLOoPlg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and beg for mercy
Date: Fri, 18 Dec 2009 18:38:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Bob Copeland <me@bobcopeland.com>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com>
In-Reply-To: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200912181838.20204.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009 06:26:29 pm Luis R. Rodriguez wrote:

> on my kernel logs. Bewildered with this issue I set out to prove to
> myself this issue was not a 2.6.32 issue and booted other kernels,
> including Ubuntu's distro kernel on 2.6.31 and then later my own built
> fresh 2.6.27.41 kernel. The issue was reproducible on all three
> kernels!
> 
> This lead me to believe this was a system / hard drive issue and
> embraced myself for a system fix. I yet needed to prove this was

Just some hints for ruling out the system / hard drive problem.

smartctl -a /dev/sdx is your friend for checking your disk (keep an eye
on anything suspicious like re-allocated sector count going up etc.)

It could be also fs related issue that shows up only under specific
conditions (i.e. almost full partition -- some file-systems starts to
crawl when the amount of available free space gets low).

HTH
--
Bartlomiej Zolnierkiewicz
