Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464Ab0ANCPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab0ANCPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763Ab0ANCPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:15:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45285 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0ANCPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:15:41 -0500
To: Joshua Pincus <joshua.pincus@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
From: Andi Kleen <andi@firstfloor.org>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
Date: Thu, 14 Jan 2010 03:15:33 +0100
In-Reply-To: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> (Joshua Pincus's message of "Wed, 13 Jan 2010 17:45:55 -0800")
Message-ID: <87ljg1fn3u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua Pincus <joshua.pincus@gmail.com> writes:

> I have a request for an additional feature to be included
> in the recent hardware breakpoints work soon to be delivered
> in kernel 2.6.33.

Sounds to me like the existing ptrace based interface
can practically all you want

(except that the "parent signal" would be wait and for
fork/exec you have to explicitely attach)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
