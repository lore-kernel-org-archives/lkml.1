Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYGZAbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYGZAbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 20:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYGZAbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 20:31:04 -0400
Received: from gw.goop.org ([64.81.55.164]:46038 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbYGZAbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 20:31:03 -0400
Message-ID: <488A7041.5070802@goop.org>
Date: Fri, 25 Jul 2008 17:30:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64: Optimize percpu accesses
References: <20080725211117.586723000@polaris-admin.engr.sgi.com> <488A613E.50305@goop.org> <488A6F5F.5000105@sgi.com>
In-Reply-To: <488A6F5F.5000105@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Yes, you're right, I wrote that quickly without really reading it back.
> My point is that now that x86_read_percpu() and x86_write_percpu() do
> evaluate to a single instruction (by definition atomic), then it doesn't
> need to be surrounded by the preempt_disable()/preempt_enable() calls.
>   

Yep, correct.

> It appears as if I'm implying that's the case for get/put_cpu_var().
>   

Right.

    J
