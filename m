Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZANSgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZANSgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbZANSfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:35:51 -0500
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:47799 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbZANSfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:35:50 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: The policy on initramfs decompression failure
To: Ingo Molnar <mingo@elte.hu>, Alain Knaff <alain@knaff.lu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>
Reply-To: 7eggert@gmx.de
Date: Wed, 14 Jan 2009 19:35:44 +0100
References: <bU0fj-7Ap-43@gated-at.bofh.it> <bU0If-8vA-19@gated-at.bofh.it> <bU6NE-1bi-3@gated-at.bofh.it> <bU837-3lq-11@gated-at.bofh.it> <bU8FR-4by-23@gated-at.bofh.it> <bU9iw-5gV-1@gated-at.bofh.it> <bUbkj-8un-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LNAae-0001yT-R7@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> Exactly how is such a warning different from other warnings that the
> kernel already emits? For which people supposedly have to set up a serial
> console? (which they dont have to)
> 
> Answer: 

A warning is given if the systen knows the correct way how to deal with the
situation, even if it shouldn't be there. How would you know that any system
being at the compiled-in default root device location (e.g. /dev/sda1, if I
did not have raid) WILL NOT boot unless I intend it to boot? Maybe it's a
rescue system supposed to run from initrd only? Or a public terminal
supposedly running from initrd + network only, where /dev/sda is the
client's USB stick? Or it's a remote setup, and panic() will reboot into the
old, working setup?

