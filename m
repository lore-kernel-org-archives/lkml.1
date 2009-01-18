Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbZARMzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbZARMzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 07:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZARMzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 07:55:37 -0500
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:45813 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859AbZARMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 07:55:36 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: The policy on initramfs decompression failure
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Reply-To: 7eggert@gmx.de
Date: Sun, 18 Jan 2009 13:55:27 +0100
References: <bU0fj-7Ap-43@gated-at.bofh.it> <bU0If-8vA-19@gated-at.bofh.it> <bU6NE-1bi-3@gated-at.bofh.it> <bU837-3lq-11@gated-at.bofh.it> <bU8FR-4by-23@gated-at.bofh.it> <bUi2r-2kd-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LOXBX-0001dZ-Fo@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> Thought about this whole thing some more, and it seems to me as follows:
> what we really want, and need, is a "panic-level=X" option, where X will
> naturally vary for differnet users.  I suspect there are many users
> today who would prefer a panic (and reboot) on a KERN_CRIT message, even
> at runtime.  For finer control, we need a message subsystem tag, but
> that is something that would be highly desirable anyway.

This will be fun if there are read errors on the CDROM.

> As such, the initramfs decompression failure should be a KERN_CRIT or
> KERN_ALERT message, and not a panic per se.

Only if you can argue that not using the initrd WILL NEVER be bad.

