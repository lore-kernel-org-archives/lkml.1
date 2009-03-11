Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZCKBiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZCKBiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZCKBiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:38:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZCKBiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:38:00 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: removing zImage support?
From: Andi Kleen <andi@firstfloor.org>
References: <49B703D4.1000008@zytor.com>
Date: Wed, 11 Mar 2009 02:15:44 +0100
In-Reply-To: <49B703D4.1000008@zytor.com> (H. Peter Anvin's message of "Tue, 10 Mar 2009 17:20:36 -0700")
Message-ID: <87fxhkg8qn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> I'm thinking again about removing zImage support.  An "allnoconfig"
> kernel (with CONFIG_EMBEDDED=y to expose additional knobs, and
> CONFIG_BINFMT_ELF=y so it can do anything at all) is currently 487K on
> i386 -- very close to the upper limit of 512K for zImage.

An alternative would be to do a concentrated effort to get rid of text bloat
again. I bet it could be stripped down to much below that again by just
attacking some low hanging fruit.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
