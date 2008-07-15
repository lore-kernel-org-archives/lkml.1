Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYGOKEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYGOKEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 06:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYGOKD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 06:03:59 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:27346 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYGOKD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:03:58 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 01/14] Introduce cpu_enabled_map and friends
From: Andi Kleen <andi@firstfloor.org>
References: <20080715023344.2528.1836.stgit@blender.achiang>
	<20080715023349.2528.9423.stgit@blender.achiang>
	<20080715031512.GF14894@parisc-linux.org>
Date: Tue, 15 Jul 2008 12:03:27 +0200
In-Reply-To: <20080715031512.GF14894@parisc-linux.org> (Matthew Wilcox's message of "Mon, 14 Jul 2008 21:15:12 -0600")
Message-ID: <87wsjnxy4w.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 10:03:26.0860 (UTC) FILETIME=[066624C0:01C8E662]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:
>
> I don't understand why we want to know about these CPUs.  Surely they
> should be 'possible', but not 'present'?  What useful thing can Linux do
> with them?

He explained it in the intro, near the end (I nearly complained about
this too when I hadn't finished reading it completely :):

|The big picture implication is that we can allow userspace
|to interact with disabled CPUs. In this particular example,
|we provide a knob that lets a sysadmin schedule any present
|CPU for firmware deconfiguration or enablement.

The reason sounds pretty exotic, but ok.

-Andi
