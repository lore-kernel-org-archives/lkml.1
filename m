Return-Path: <linux-kernel-owner+w=401wt.eu-S936643AbXHHBIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936643AbXHHBIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936293AbXHHBHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:07:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36133 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936189AbXHHBHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:07:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com>
	<20070807142928.GA18839@in.ibm.com>
	<46B8AECA.7050908@fujitsu-siemens.com>
Date: Tue, 07 Aug 2007 19:04:50 -0600
In-Reply-To: <46B8AECA.7050908@fujitsu-siemens.com> (Martin Wilck's message of
	"Tue, 07 Aug 2007 19:41:30 +0200")
Message-ID: <m1ir7qg7kd.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A couple of questions.

How bad is it if you just run with irqpoll in the kdump kernel?
If running with irqpoll is usable that is probably preferable
to putting in a hardware work around we can survive without.


Have you done any looking at moving where the kernel initalizes
io_apics?  One of the todo items on the path is to leave
io_apic mode enabled and just startup the kernel in io_apic
mode.

When doing that a version of your work around (if needed)
would certainly be reasonable.

My general concern is that the trickier we get in the code
running in the crashed kernel the less reliable the entire
process will be.

Eric
