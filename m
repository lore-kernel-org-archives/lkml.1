Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0BOLRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:17:06 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33226 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab0BOLRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:17:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=q8klRlEenmpfjpL+ILd1JX63nk9rrXpW7qMc5lCLnrRsmJO3ZshKyK7ZqRazOooxl2
         tEErZBsC1vKWAyjoyXgjzinngbEhoy4vVLoDF73kmQpyORpEJ4ULcPRezNnC32uKIJUG
         gZuwC5li1EFueYZqCFuJO1O+qJsbHYgjXaKYE=
Subject: Re: 2.6.31 and OOM killer = bug?
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Starikov <ant.starikov@gmail.com>
In-Reply-To: <20100215101917.15552a51.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 15 Feb 2010 12:16:57 +0100
Cc: linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <548A11C6-8C8C-45EF-92E7-72C3DF47F9FD@gmail.com>
References: <E0975165-4185-47A9-A15F-B46774A5F6DA@gmail.com> <20100215101917.15552a51.kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15, 2010, at 2:19 AM, KAMEZAWA Hiroyuki wrote:
> At first, what is the version of kernel you are comparing with ? 2.6.22?(If OpenSuse10)
> If so, many changes since that..


Latest kernel version where OOM killer worked as it should in our setup was 2.6.29.

> Anyway, I think it's not appreciated to depend on OOM-Kill on swapless-system.
> I recommend you to use cgroup "memory" to encapsulate your apps (but please check
> the performance regression can be seen or not..)

OK, I will check it.

Thanks, 
Anton.