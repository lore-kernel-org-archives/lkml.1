Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYHZL0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYHZL0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYHZL0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:26:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45400 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYHZL0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:26:24 -0400
To: Pavel Machek <pavel@suse.cz>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
From: Andi Kleen <andi@firstfloor.org>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
	<20080826095032.GA309@elf.ucw.cz>
Date: Tue, 26 Aug 2008 13:26:18 +0200
In-Reply-To: <20080826095032.GA309@elf.ucw.cz> (Pavel Machek's message of "Tue, 26 Aug 2008 11:50:32 +0200")
Message-ID: <871w0ct3tx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> writes:
>
> "ACPI" and "safe" in one sentence. 

ACPI is safe in that a lot of systems won't even boot anymore without ACPI.

> /me bets this will break lot of machines.

The ACPI reboot is just a write to a IO port with a fallback, so it
should be fairly safe even if the field should be wrong.

-Andi
