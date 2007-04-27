Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbXDZXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbXDZXlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbXDZXlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:41:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXDZXlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:41:16 -0400
To: Paul Fulghum <paulkf@microgate.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compat_ioctl question
References: <1177620717.5060.11.camel@amdx2.microgate.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Apr 2007 02:38:56 +0200
In-Reply-To: <1177620717.5060.11.camel@amdx2.microgate.com>
Message-ID: <p73bqha3b33.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum <paulkf@microgate.com> writes:
> 
> 1. define compat_ioctl() file operation for device and
>     implement translation code in individual driver
> 2. add COMPATIBLE_IOCTL entry to include/linux/compat_ioctl.h
>     to mark an ioctl code as the same in any environment
> 3. add HANDLE_IOCTL entry to fs/compat_ioctl.c with translation code
>     implemented in the same file
> 
> There is no way to implement #1 for a tty driver without
> modifying the kernel tty code to allow registration of a
> compat_ioctl() handler.

(1) is really the recommended solution for all new code

I would recommend you modify the tty driver to pass compat_ioctl
through through. Should not do very hard.

-Andi
