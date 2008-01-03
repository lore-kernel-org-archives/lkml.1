Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYACRvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYACRvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYACRvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:51:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:56954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbYACRvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:51:39 -0500
To: Bernd Prager <bernd@prager.ws>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel config for AMD Athlon 64 X2 4200+ Manchester
From: Andi Kleen <andi@firstfloor.org>
References: <bb078b9bc5a6138dc7ac78609713efdd@prager.ws>
Date: Thu, 03 Jan 2008 18:51:37 +0100
In-Reply-To: <bb078b9bc5a6138dc7ac78609713efdd@prager.ws> (Bernd Prager's message of "Thu\, 3 Jan 2008 09\:05\:28 -0700")
Message-ID: <p738x36hk5y.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Prager <bernd@prager.ws> writes:
> $  cat /proc/cpuinfo 
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 43
> model name      : AMD Hammer Family processor - Model Unknown

This means your BIOS does not know your specific CPU. This could to all kinds
of subtle problems. Try to find a BIOS upgrade.

> Any ideas how I can configure the kernel to fix that?

The usual mistake is to not enable CONFIG_ACPI, although if the BIOS 
is really old and doesn't detect the dualcoreness of your CPU then that
might also not help.

-Andi
