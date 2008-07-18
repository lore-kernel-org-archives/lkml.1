Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYGRLYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYGRLYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYGRLYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:24:36 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:46448 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYGRLYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:24:36 -0400
To: David Miller <davem@davemloft.net>
Cc: roland@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] tracehook
From: Andi Kleen <andi@firstfloor.org>
References: <20080717072541.F390E15411D@magilla.localdomain>
	<20080718.022035.208722773.davem@davemloft.net>
Date: Fri, 18 Jul 2008 13:24:33 +0200
In-Reply-To: <20080718.022035.208722773.davem@davemloft.net> (David Miller's message of "Fri, 18 Jul 2008 02:20:35 -0700 (PDT)")
Message-ID: <87vdz3qvta.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2008 11:24:31.0663 (UTC) FILETIME=[D9496BF0:01C8E8C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
>
> The other arch's with compat support will have this same exact issue.

On x86-64 the sign extension is in C code, so it would be somewhat more
complicated to do a generic table or converter.

I think the tracer will always need to know if it's tracing 32bit
or 64bit though, because the interfaces are not always 100% compatible.
e.g. I suspect any serious one will need to look at memory 
arguments for some cases and those generally differ.

-Andi
