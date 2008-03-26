Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYCZFaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYCZFaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 01:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYCZFaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 01:30:22 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:50855 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYCZFaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 01:30:21 -0400
To: =?utf-8?b?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
Cc: "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: gcc-4.3 considers unaligned accesses on X86 as undefined
References: <47E965BD.7010604@gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 26 Mar 2008 06:30:17 +0100
In-Reply-To: <47E965BD.7010604@gmail.com>
Message-ID: <87d4pinjbq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Mar 2008 05:23:40.0189 (UTC) FILETIME=[8CE92CD0:01C88F01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin <edwintorok@gmail.com> writes:

> At -O3 it generates vectorized code that  _relies_  on the fact that
> pointers are always aligned (unless you use packed attributes, etc.),
> and the resulting code crashes if the pointer is unaligned.  (-O3 -msse
> on 32-bit, and simply -O3 on 64-bit since -msse is default)

The 2.6 kernel disables SSE and MMX code generation explicitely.
2.4 should be also safe unless someone misguided recompiles it with -O3.

-Andi
