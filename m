Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYBPLKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYBPLKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 06:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYBPLKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 06:10:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbYBPLKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 06:10:15 -0500
Date: Sat, 16 Feb 2008 03:09:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Russell Leidich <rml@google.com>
Subject: Re: 2.6.25-rc2-mm1: build failure (x86)
Message-Id: <20080216030949.5b11ba4c.akpm@linux-foundation.org>
In-Reply-To: <20080216105737.GA6561@joi>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216105737.GA6561@joi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 11:59:07 +0100 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> arch/x86/kernel/built-in.o: In function `amd_smp_thermal_interrupt':
> (.text+0xe03b): undefined reference to `mce_log_therm_throt_event'
> arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> (.text+0x12239): undefined reference to `setup_trampoline'
> 
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.25-rc2-mm1
> # Sat Feb 16 11:32:49 2008

ho hum, thanks.  I think I'll drop x86-amd-thermal-interrupt-support.patch.
 I don't think it's the final version anwyay.

