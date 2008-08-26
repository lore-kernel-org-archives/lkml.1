Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbYHZMbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbYHZMbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYHZMbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:31:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54980 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbYHZMbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:31:31 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
From: Andi Kleen <andi@firstfloor.org>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
	<20080826095032.GA309@elf.ucw.cz> <48B3D579.40502@qumranet.com>
	<20080826113317.520cbab1@lxorguk.ukuu.org.uk>
	<48B3F3A9.8030709@qumranet.com>
Date: Tue, 26 Aug 2008 14:31:22 +0200
In-Reply-To: <48B3F3A9.8030709@qumranet.com> (Avi Kivity's message of "Tue, 26 Aug 2008 15:14:33 +0300")
Message-ID: <87tzd8rm91.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@qumranet.com> writes:
>
> If a machine has acpi, and the reset register is wired to the launch
> controller, then perhaps this change is unsafe.  Don't issue sysrq-b
> on such machines.

Even if it's wired to the launch controller the launch controller
would need to be quite quick to do something before the following
triple fault/keyboard reset->PCI reset stops it again.

-Andi
