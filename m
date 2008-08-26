Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbYHZNZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbYHZNZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbYHZNZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:25:43 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61605 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757820AbYHZNZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:25:40 -0400
Date: Tue, 26 Aug 2008 14:24:20 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Avi Kivity <avi@qumranet.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
In-Reply-To: <48B3F3A9.8030709@qumranet.com>
Message-ID: <Pine.LNX.4.55.0808261406330.28361@cliff.in.clinika.pl>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
 <20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com>
 <20080826113317.520cbab1@lxorguk.ukuu.org.uk> <48B3F3A9.8030709@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008, Avi Kivity wrote:

> Most machines are recent machines.

 This is a bold statement I would say.  Any numbers to back it up?

> If a machine doesn't have acpi, this change is safe.
> 
> If a machine has acpi, but doesn't have the reset register set in the 
> FADT, this change is safe.
> 
> If a machine has acpi, and the reset register is set incorrectly, this 
> change is safe.
> 
> If a machine has acpi, and the reset register is wired to the launch 
> controller, then perhaps this change is unsafe.  Don't issue sysrq-b on 
> such machines.

 If a machine has ACPI and it is broken randomly, then the results can be
arbitrary.  Hopefully not destructively.  If even such a simple thing as
wiring the reset line so that it functions correctly can be got wrong,
more so can be more complex matters.

 Failing a better alternative, I suppose the change has to go in though.

  Maciej
