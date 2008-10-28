Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbYJ1D2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbYJ1D2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYJ1D2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:28:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbYJ1D2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:28:43 -0400
Date: Mon, 27 Oct 2008 20:28:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/timex.h: cleanup for userspace
Message-Id: <20081027202827.30e6c038.akpm@linux-foundation.org>
In-Reply-To: <1225017451-19133-1-git-send-email-vapier@gentoo.org>
References: <1225017451-19133-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 06:37:31 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> Move all the kernel-specific defines and includes into the __KERNEL__
> section so that they don't get leaked into userspace.
> 

checkpatch correctly instructs us to use linux/param.h, not asm/param.h.

This:

--- a/include/linux/timex.h~linux-timexh-cleanup-for-userspace-checkpatch-fixes
+++ a/include/linux/timex.h
@@ -165,8 +165,8 @@ struct timex {
 #ifdef __KERNEL__
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/param.h>
 
-#include <asm/param.h>
 #include <asm/timex.h>
 
 /*
_

seems Obviously Safe to me.  Do you agree?

(please use checkpatch - sometimes it's useful!)
