Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431Ab0AYVCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0AYVCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624Ab0AYVCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:02:20 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:44984 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0AYVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:02:19 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Dimitry Golubovsky <golubovsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmap a /proc/<pid>/mem file?
References: <bcba51a1001251242q1478b506k92a1ac86967e1524@mail.gmail.com>
X-Yow: I wonder if I could ever get started in the credit world?
Date: Mon, 25 Jan 2010 22:02:17 +0100
In-Reply-To: <bcba51a1001251242q1478b506k92a1ac86967e1524@mail.gmail.com>
	(Dimitry Golubovsky's message of "Mon, 25 Jan 2010 15:42:55 -0500")
Message-ID: <m2zl417vae.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitry Golubovsky <golubovsky@gmail.com> writes:

> Say I have a parent and a child processes. Can the parent process
> access the child process memory using mmap() over /proc/<pid>/mem file
> where <pid> is child's pid?

Only if the parent is the tracer of the child.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
