Return-Path: <linux-kernel-owner+w=401wt.eu-S2992956AbXDYTHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992956AbXDYTHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992954AbXDYTHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:07:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992956AbXDYTHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:07:39 -0400
Date: Wed, 25 Apr 2007 12:07:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Sunil Naidu" <akula2.shark@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: menuconfig issue (checklist) in 2.6.20.7 & 2.6.21-rc7 ?
Message-Id: <20070425120730.4c267c15.akpm@linux-foundation.org>
In-Reply-To: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
References: <8355959a0704250724g3614d293h2dd08833a6ef473b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 19:54:14 +0530 "Sunil Naidu" <akula2.shark@gmail.com> wrote:

> I was trying to compile those kernels with make menuconfig. I am
> getting the error in scripts/kconfig/lxdialog/checklist.o. Here is the
> output:
> 
> [sukhoi@Akula2 linux-2.6.20.7]$ sudo make menuconfig
>   HOSTCC  scripts/kconfig/lxdialog/checklist.o
> In file included from scripts/kconfig/lxdialog/checklist.c:24:
> scripts/kconfig/lxdialog/dialog.h:32:20: error: curses.h: No such file
> or directory

I guess you need to install the curses development package.  Here it's called
ncurses-devel.
