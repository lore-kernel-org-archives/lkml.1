Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYE1S15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYE1S15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYE1S1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:27:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:8092 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYE1S1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K+7JzE65Iwymb1Lqa5Rk9LaiYkjDU9CcQLoVurGELHAH1RmjgBXKZVhSH8MhJguY6u2XQmem1naLo2sXJxy/ryxwhwlyOc6ituEvyqWQN27vvD6itxmYb9wLSw92O6LbhsD4K7dXhkniqpspD58C1ulNKOu5TuUIyvWZisL9/z8=
Message-ID: <6844644e0805281127s47be5b92i71b9684fb41cc596@mail.gmail.com>
Date: Wed, 28 May 2008 14:27:47 -0400
From: "Doug Reiland" <dreiland@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild changes since 2.6.21??
In-Reply-To: <6844644e0805280923q6ae8fdd6pcf92f726f420afe4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6844644e0805280923q6ae8fdd6pcf92f726f420afe4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By bad, drivers/power/Makefile is ok.
I thought I reproduced the issue there.

On Wed, May 28, 2008 at 12:23 PM, Doug Reiland <dreiland@gmail.com> wrote:
> There are some makefiles that look at CONFIG_XXXX variables to make
> decisions. For example, drivers/power/Makefile has the following
> lines:
>
> ifeq ($(CONFIG_SYSFS),y)
> power_supply-objs += power_supply_sysfs.o
> endif
>
>
> If I run make clean or make mrproper, it doesn't see CONFIG_SYSFS set
> anymore so it doesn't cleanup power_supply_sysfs.o.
>
> This is for 2.6.25, but I think this use to work for 2.6.21. I am
> using drivers/power/Makefile as an example, but I am seeing the same
> thing for my driver's Makefile.
>
> Thanks in advance.
>
