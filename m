Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbYDTE0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbYDTE0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 00:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYDTE0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 00:26:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYDTE0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 00:26:06 -0400
Message-ID: <480AC505.1030301@zytor.com>
Date: Sun, 20 Apr 2008 00:22:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: remove unused code and data in nexgen.c
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com> <1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>
In-Reply-To: <1208660074-7324-3-git-send-email-dmitri.vorobiev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Vorobiev wrote:
> Nobody calls the function nexgen_init_cpu(), therefore it
> can be removed. The variable nexgen_cpu_dev is used only by
> this function, so this patch removes useless data as well.
> 
> This patch was build-tested using defconfigs for i386 and x86_64.
> It also survived a few randconfig instances for i386. Runtime
> tests were performed by booting 32-bit and 64-bit x86 boxen up to
> the shell prompt.

NAK.  This is broken.

The reason nexgen_cpu_dev is unreferenced is because the file is missing 
a cpu_vendor_dev_register(), which should be added.

	-hpa

