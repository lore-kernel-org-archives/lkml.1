Return-Path: <linux-kernel-owner+w=401wt.eu-S1763686AbZAUFXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763686AbZAUFXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbZAUFVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:21:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53789 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759309AbZAUFV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:21:29 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Avuton Olrich <avuton@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due to dc1e35c
From: Andi Kleen <andi@firstfloor.org>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
	<4974CC8B.1030403@zytor.com>
	<3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com>
	<4974DD86.2090300@zytor.com>
	<20090119201115.GD31356@linux-os.sc.intel.com>
	<3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com>
	<20090119215736.GE31356@linux-os.sc.intel.com>
	<4974F9A8.7060107@zytor.com>
Date: Wed, 21 Jan 2009 06:20:37 +0100
In-Reply-To: <4974F9A8.7060107@zytor.com> (H. Peter Anvin's message of "Mon, 19 Jan 2009 14:07:36 -0800")
Message-ID: <87bpu1dyl6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> We should, or if this block is reversible, we should probably just
> undo it (the reason people put this block in places is because of,
> ahem, inferior operating systems having bugs.)

Even if it's undone it would be still a good idea to make the cpuid
code bulletproof, just in case someone writes a broken emulator or similar.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
