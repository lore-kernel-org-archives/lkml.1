Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZGTHmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZGTHmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZGTHmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:42:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42125 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZGTHmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:42:16 -0400
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC patch] delete improper hot pluggable code of memory affinity
From: Andi Kleen <andi@firstfloor.org>
References: <3877989d0907160218l4a28791v90ad22cc048c3440@mail.gmail.com>
Date: Mon, 20 Jul 2009 09:42:11 +0200
In-Reply-To: <3877989d0907160218l4a28791v90ad22cc048c3440@mail.gmail.com> (Luming Yu's message of "Thu, 16 Jul 2009 17:18:37 +0800")
Message-ID: <87my6z4x7w.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luming Yu <luming.yu@gmail.com> writes:
>
> The downside of this patch is *some useful info* is lost and a follow
> up patch is needed.

A lot of the heuristics in the hotadd code are obsolete since x86-64
only supports sparsemem/vmememap

I posted another patch for this and also have a followup
series (not posted yet) to address some more problems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
