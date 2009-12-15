Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbZLOOHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbZLOOHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbZLOOHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:07:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39296 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760256AbZLOOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:07:33 -0500
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Subject: Re: [RFC, PATCH 3/4] elf_core_dump(): make offset calculation and writing processes explicit
From: Andi Kleen <andi@firstfloor.org>
References: <20091215.114137.104035145.d.hatayama@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 15:07:31 +0100
In-Reply-To: <20091215.114137.104035145.d.hatayama@jp.fujitsu.com> (Daisuke HATAYAMA's message of "Tue, 15 Dec 2009 11:41:37 +0900 (JST)")
Message-ID: <87ocm0wct8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com> writes:
>
> However, the clause 1. is not always possible, since one
> cannot assume that dump_seek() function always supports
> the seek in the minus direction. Consider no_llseek.

Not even forward seek is always supported, consider core dumping
to a pipe.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
