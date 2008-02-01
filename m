Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbYBAFqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbYBAFqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYBAFqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:46:05 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33684 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYBAFqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:46:03 -0500
Message-ID: <47A2B21E.2090508@davidnewall.com>
Date: Fri, 01 Feb 2008 16:16:06 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk> <1201815920-24669-2-git-send-email-ijc@hellion.org.uk> <1201815920-24669-3-git-send-email-ijc@hellion.org.uk> <47A26B2F.8080001@davidnewall.com> <47A272D8.7030106@zytor.com>
In-Reply-To: <47A272D8.7030106@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> David Newall wrote:
>> Isn't a crc32 calculation already defined?  Yes; in lib/crc32.c.  One is
>> surely enough.
>
> As long as it can be included in user-space code we should use that one. 

You're right.  I misread the patch.  I thought the calculation was being
added to kernel code.
