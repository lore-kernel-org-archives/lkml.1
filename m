Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbYGQScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbYGQScU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYGQScH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:32:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566AbYGQScF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:32:05 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs 	(part1: use kprobe symbol_name/offset instead of address)
References: <1216146802.3312.95.camel@localhost.localdomain>
	<487E78ED.30804@redhat.com>
	<1216249383.3358.69.camel@localhost.localdomain>
	<487E8CE4.70105@redhat.com>
	<1216259391.3358.85.camel@localhost.localdomain>
	<1216304290.5515.11.camel@localhost.localdomain>
	<1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 17 Jul 2008 14:30:36 -0400
In-Reply-To: <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain> (James Bottomley's message of "Thu, 17 Jul 2008 11:58:34 -0500")
Message-ID: <y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> [...]
> Just by way of illustration, this is systemtap fixed up according to
> suggestion number 1.  You can see now using your test case that we get:
>
> # probes
> kernel.function("do_open@fs/block_dev.c:929") /* pc=<lookup_bdev+0x90> */ /* <- kernel.function("do_open") */
> kernel.function("do_open@fs/nfsctl.c:24") /* pc=<sys_nfsservctl+0x6a> */ /* <- kernel.function("do_open") */
> kernel.function("do_open@ipc/mqueue.c:642") /* pc=<sys_mq_unlink+0x130> */ /* <- kernel.function("do_open") */
> [...]

Can you explain in detail how you believe this is materially
different from offsetting from _stext?

- FChE
