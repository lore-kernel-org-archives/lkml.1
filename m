Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbYBFBLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbYBFBLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757397AbYBFBLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:11:37 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:27665 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYBFBLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:11:37 -0500
Date: Tue, 5 Feb 2008 17:09:39 -0800
From: Randy Dunlap <randy.dunlap@ORACLE.COM>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
Message-Id: <20080205170939.10085936.randy.dunlap@oracle.com>
In-Reply-To: <1201856568.3804.8.camel@cthulhu.hellion.org.uk>
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk>
	<1201815920-24669-2-git-send-email-ijc@hellion.org.uk>
	<1201815920-24669-3-git-send-email-ijc@hellion.org.uk>
	<47A24765.3070300@zytor.com>
	<1201856568.3804.8.camel@cthulhu.hellion.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Feb 2008 09:02:48 +0000 Ian Campbell wrote:

> ---
> >From 1c614383dc9cb0c7791ebab386dc012db336b28c Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ijc@hellion.org.uk>
> Date: Fri, 1 Feb 2008 09:01:22 +0000
> Subject: [PATCH] x86: add a crc32 checksum to the kernel image.
> 
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  Documentation/i386/boot.txt |    7 +++
>  arch/x86/boot/tools/build.c |   88 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 94 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
> index b5f5ba1..f853d49 100644
> --- a/Documentation/i386/boot.txt
> +++ b/Documentation/i386/boot.txt
> @@ -531,6 +531,13 @@ Protocol:	2.08+
>  
>    The length of the compressed payload.
>  
> +**** THE IMAGE CHECKSUM
> +
> +The CRC-32 is calculated over the entire file using an initial
> +remainder of 0xffffffff.  The checksum is appended to the file

Run-on sentences.
Use period (full stop) or semi-colon at end of above sentence.
If using a period, capitalize the next word.  Thanks.


> +therefore the CRC of the file up to the limit specified in the syssize
> +field of the header is always 0.
> +
>  **** THE KERNEL COMMAND LINE
>  
>  The kernel command line has become an important way for the boot

---
~Randy
