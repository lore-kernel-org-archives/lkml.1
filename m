Return-Path: <linux-kernel-owner+w=401wt.eu-S934899AbYBABRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899AbYBABRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbYBABQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:16:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbYBABQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:16:54 -0500
Message-ID: <47A272D8.7030106@zytor.com>
Date: Thu, 31 Jan 2008 17:16:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk> <1201815920-24669-2-git-send-email-ijc@hellion.org.uk> <1201815920-24669-3-git-send-email-ijc@hellion.org.uk> <47A26B2F.8080001@davidnewall.com>
In-Reply-To: <47A26B2F.8080001@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Isn't a crc32 calculation already defined?  Yes; in lib/crc32.c.  One is
> surely enough.

As long as it can be included in user-space code we should use that one.

	-hpa
