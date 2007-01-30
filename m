Return-Path: <linux-kernel-owner+w=401wt.eu-S965391AbXA3PMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391AbXA3PMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965590AbXA3PMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:12:15 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46644 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965391AbXA3PMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:12:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compile and link utsname_sysctl.o
References: <20070129001207.71ea3470.akpm@osdl.org> <45BE6E4C.60207@free.fr>
Date: Tue, 30 Jan 2007 08:11:39 -0700
In-Reply-To: <45BE6E4C.60207@free.fr> (Laurent Riffard's message of "Mon, 29
	Jan 2007 22:59:40 +0100")
Message-ID: <m1tzy8h7mc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Riffard <laurent.riffard@free.fr> writes:

> The utsname stuff has been moved from kernel/sysctl.c to the new file
> utsname_sysctl.c. Let's use it...
>
> Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>

Hmm.  Maybe something got lost along the way but I have this
line in my kernel/Makefile and in the patch I sent out.

obj-$(CONFIG_SYSCTL) += utsname_sysctl.o


Do you not have that?  What problem are you seeing?


Eric
