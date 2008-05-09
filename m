Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbYEIXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbYEIXQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 19:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbYEIXQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 19:16:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35658 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbYEIXQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 19:16:10 -0400
Message-ID: <4824DB36.8000500@firstfloor.org>
Date: Sat, 10 May 2008 01:16:06 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: /proc/kallsyms broken in 2.6.26-rc1-git6
References: <20080509174148.GA22246@basil.nowhere.org> <482491D6.9030205@grupopie.com> <4824A7B6.70306@firstfloor.org> <4824AD3C.3070506@grupopie.com>
In-Reply-To: <4824AD3C.3070506@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That's not for me to judge, but I believe it has always been like that.

No, normally /proc/kallsyms looks similar to System.tap. Where are all
these DW.* symbols coming from? They didn't use to be there and don't
make any sense because they don't have any valid kernel addresses.

> I just wanted to understand if you noticed a change in behavior (which
> is probably a bug) or if it has always been like that but you just
> noticed how ugly it is.

I noticed a change in behavior.

> Maybe you also have some debug or markers configuration or something
> that is generating extra symbols to a special section that is just
> making the problem look worse now.

Nothing particular. I uploaded the config at
http://halobates.de/basil-config

> Anyway, I can change the way kallsyms works, but that has to be done
> with some care because there are some userspace tools that read
> /proc/kallsyms and we don't want to break those. A proper testing period
> through -mm should take care of that, though.

It's the other way round -- kallsyms changed and that change will likely
break programs.

-Andi



