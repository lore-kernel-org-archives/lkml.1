Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbXEMTt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbXEMTt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXEMTtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:49:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51247 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbXEMTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:49:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	<m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
	<86802c440705122329y27c6ef92v8cff43d52b99ae69@mail.gmail.com>
	<m1abw9qkve.fsf@ebiederm.dsl.xmission.com>
	<86802c440705122355r5f811d5bg2006b0b22ca885e6@mail.gmail.com>
	<m11whlqk1g.fsf@ebiederm.dsl.xmission.com>
	<86802c440705130027vce147dma85a07de6489d666@mail.gmail.com>
	<86802c440705131101r5b32e0b9j28e2248813b25b64@mail.gmail.com>
Date: Sun, 13 May 2007 13:49:02 -0600
In-Reply-To: <86802c440705131101r5b32e0b9j28e2248813b25b64@mail.gmail.com>
	(Yinghai Lu's message of "Sun, 13 May 2007 11:01:33 -0700")
Message-ID: <m1646wpkr5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> Eric,
>
> I got one question about kexec and bzImage on 64bit kernel.
>
> The bzImage for 64bit kernel must be loaded under 4G?
> but vmlinux for 64bit kernel could be loaded above 4G.
>
> So is there any plan to use 64bit entry point (startup_64) in
> arch/x86_64/boot/compressed/vmlinux in bzImage? so you may
> load bzImage above 4G too.

We have big boot protocol revision coming up to more clearly document
what is needed to work with the native entry points.  It is a 2.6.23
targeted thing and that is one of the things that we are likely to
look at.

Eric
