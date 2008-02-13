Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYBMPES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYBMPES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYBMPED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:04:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:52904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbYBMPEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:04:00 -0500
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, marcelo@kvack.org, daniel.spang@gmail.com,
       riel@redhat.com, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, pavel@ucw.cz, a1426z@gawab.com,
       jonathan@jonmasters.org, zlynx@acm.org
Subject: Re: [PATCH 4/8][for -mm] mem_notify v6: memory_pressure_notify() caller
From: Andi Kleen <andi@firstfloor.org>
References: <2f11576a0802090724s679258c4g7414e0a6983f4706@mail.gmail.com>
	<20080212145651.69cc34a5.akpm@linux-foundation.org>
	<20080213152204.D894.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Wed, 13 Feb 2008 16:03:58 +0100
In-Reply-To: <20080213152204.D894.KOSAKI.MOTOHIRO@jp.fujitsu.com> (KOSAKI Motohiro's message of "Wed\, 13 Feb 2008 15\:37\:13 +0900")
Message-ID: <p73y79o290h.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
>
> to be honest, I don't think at mem-cgroup until now.

There is not only mem-cgroup BTW, but also NUMA node restrictons from
NUMA memory policy. So this means a process might not be able to access
all memory.

-Andi
