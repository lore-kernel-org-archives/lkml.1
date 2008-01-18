Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYARFAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYARFAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYARFAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:00:40 -0500
Received: from mx1.suse.de ([195.135.220.2]:57797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYARFAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:00:39 -0500
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: add is_f00f_bug helper to fault_32|64.c
From: Andi Kleen <andi@firstfloor.org>
References: <1200610456.5724.41.camel@brick>
Date: Fri, 18 Jan 2008 06:00:38 +0100
In-Reply-To: <1200610456.5724.41.camel@brick> (Harvey Harrison's message of "Thu\, 17 Jan 2008 14\:54\:16 -0800")
Message-ID: <p73d4rzbudl.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> writes:

> Further towards unifying these files, add another helper
> in same spirit as is_errata93.

The better way to handle this would be to move all these workarounds
into notifiers that only get registered on the CPUs that actually have
the bugs.

There is right now no die notifier in the right place for this,
but you could just add one there. This is no performance critical
place.

-Andi
