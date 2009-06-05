Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZFEAuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZFEAuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZFEAuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:50:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbZFEAug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:50:36 -0400
Date: Thu, 4 Jun 2009 17:50:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: jason.wessel@windriver.com, kgdb-bugreport@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kgdbts: unify/generalize gdb breakpoint adjustment
Message-Id: <20090604175030.55cc4a68.akpm@linux-foundation.org>
In-Reply-To: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
References: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Jun 2009 03:17:30 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> +	instruction_pointer(&kgdbts_regs) += offset;

instruction_pointer() cannot be used as an lvalue, thankfully.

x86_64:

drivers/misc/kgdbts.c: In function 'check_and_rewind_pc':
drivers/misc/kgdbts.c:306: error: invalid lvalue in assignment

