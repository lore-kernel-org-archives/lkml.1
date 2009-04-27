Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZD0QD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZD0QD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbZD0QDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:03:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46125 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbZD0QDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:03:47 -0400
Message-ID: <49F5D70F.6070309@zytor.com>
Date: Mon, 27 Apr 2009 09:02:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tglx@linutronix.de,
       mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: unify arch/x86/boot/compressed/vmlinux_*.lds
References: <tip-51b26ada79b605ed709ddcedbb6012e8f8e0ebed@git.kernel.org>
In-Reply-To: <tip-51b26ada79b605ed709ddcedbb6012e8f8e0ebed@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Linus Torvalds wrote:
> 
> Also, notice the comment in the unified vmlinux.lds.S talks about
> "head_64" and "startup_32" which is an odd and incorrect mix, but that was
> actually what the old 64-bit only lds file had, so the confusion isn't
> new, and now that mixing is arguably more accurate thanks to the
> vmlinux.lds.S file being shared between the two cases ;)
> 

It's correct, IIRC; the 64-bit code has startup_32 and startup_64, since
it is entered in 32-bit mode; startup_32 marks the entrypoint in the
beginning of the file.

	hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

