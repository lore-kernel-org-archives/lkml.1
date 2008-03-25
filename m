Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYCYSaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYCYSaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbYCYSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:30:07 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1645 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbYCYSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:30:06 -0400
Subject: Re: [PATCH 134/148] include/asm-x86/uaccess_64.h: checkpatch
	cleanups - formatting only
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080325152559.GA20898@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
	 <1206259443-13210-135-git-send-email-joe@perches.com>
	 <20080325152559.GA20898@elte.hu>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 11:29:27 -0700
Message-Id: <1206469767.4845.97.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 16:25 +0100, Ingo Molnar wrote:
> hm, you apparently never built this on 64-bit x86?

Correct. x86(_32) defconfig and allyesconfig only.

> The above has a trivial typo.

Careless.
I'll set up an x86-64 cross-compiler.

Before building I did
s/__LINE__/0/g
to minimize the md5sum differences

and md5sum/diff and objdump -Dx/diff and inspected
the objects before and after.

