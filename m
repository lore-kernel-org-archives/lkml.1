Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbYJXSEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbYJXSEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYJXSE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:04:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60123 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYJXSE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:04:28 -0400
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MCEs
From: Andi Kleen <andi@firstfloor.org>
References: <20081024124502.GA9425@codeblau.de>
Date: Fri, 24 Oct 2008 20:04:29 +0200
In-Reply-To: <20081024124502.GA9425@codeblau.de> (Felix von Leitner's message of "Fri, 24 Oct 2008 14:45:02 +0200")
Message-ID: <87r66598eq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felix von Leitner <felix-linuxkernel@fefe.de> writes:

> This is the kind of MCE that freezes the box and causes a panic.  The
> trace does not end up in syslog.  I found a program called mcelog which
> I am supposed to call regularly from cron, but how can that help me when
> the first MCE I get insta-panics the box?

When you do a warm boot (not power cycle, but reset button or 
panic=30) then the panic mce will be logged after reboot.

> Now the most common causes for MCEs are apparently heat issues and bad
> memory.  I can rule out both.  Could this be an artifact of some bad
> ACPI tables?
>
> How do you debug this kind of problem?

It's some sort of hardware problem, debugging it typically
either involves fixing the cooling or exchanging components.

-Andi

