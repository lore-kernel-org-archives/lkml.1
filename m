Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab0AOXon (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932381Ab0AOXom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:44:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932198Ab0AOXom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:44:42 -0500
Date: Fri, 15 Jan 2010 15:44:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow linker to eliminate unused functions in lib/*
Message-Id: <20100115154404.da44ba5a.akpm@linux-foundation.org>
In-Reply-To: <20100109165155.GD20773@basil.fritz.box>
References: <20100105145917.GA25570@basil.fritz.box>
	<20100108162930.a011749a.akpm@linux-foundation.org>
	<20100109165155.GD20773@basil.fritz.box>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jan 2010 17:51:56 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Allow linker to eliminate unused functions in lib/*

i386 allmodconfig:

lib/lib-syms.c:21: error: '__div64_32' undeclared here (not in a function)
lib/lib-syms.c:21: warning: type defaults to 'int' in declaration of '__div64_32'

I'll drop 

lib-allow-linker-to-eliminate-unused-functions.patch
lib-allow-linker-to-eliminate-unused-functions-fix.patch
lib-allow-linker-to-eliminate-unused-functions-fix-2.patch

for now and will return the patch for warranty repairs, please.

lib-allow-linker-to-eliminate-unused-functions-fix.patch is a
linux-next thing, so if you base the next version on mainline, please
remind me to resurrect
lib-allow-linker-to-eliminate-unused-functions-fix.patch.

I have travel coming up and won't be very functional until late next
week.
