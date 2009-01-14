Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZANWsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZANWsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZANWsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:48:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610AbZANWsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:48:04 -0500
Date: Wed, 14 Jan 2009 14:47:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, johnstul@us.ibm.com,
       gregkh@suse.de, mingo@redhat.com, magnus.damm@gmail.com,
       tglx@linutronix.de
Subject: Re: [RESEND][PATCH] early platform drivers V2
Message-Id: <20090114144705.1785bc38.akpm@linux-foundation.org>
In-Reply-To: <20090114105436.18974.45429.sendpatchset@rx1.opensource.se>
References: <20090114105436.18974.45429.sendpatchset@rx1.opensource.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 19:54:36 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> This patch is V2 of the early platform driver implementation.

Is this checkpatch whine:

WARNING: consider using strict_strtoul in preference to simple_strtoul
#112: FILE: drivers/base/platform.c:1017:
+                       id = simple_strtoul(buf +

total: 0 errors, 1 warnings, 201 lines checked

appropriate?

If the user provided "43foo", do we want to treat that as 42, or as
error?

If the user provided just "foo" then afacit we'll currently treat that
as zero.


<this is all mad guesswork, as I don't have any idea what the user
interfacce to this feature looks like>

