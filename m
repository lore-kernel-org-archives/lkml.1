Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYHYKgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYHYKgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYHYKg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:36:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYHYKg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:36:27 -0400
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap
	intensive multi-threaded task
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48B287D8.1000000@gmail.com>
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins>
	 <48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins>
	 <48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins>
	 <48B287D8.1000000@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 25 Aug 2008 12:36:22 +0200
Message-Id: <1219660582.8515.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 13:22 +0300, Török Edwin wrote:

> Well, the real program (clamd) that this testprogram tries to simulate 
> does an mmap for almost every file, and I have lots of small files.
> 6.5G, 114122 files, average size 57k.
> 
> I'll run latencytop again, last time it has showed 100ms - 500ms latency 
> for clamd, and it was about mmap, I'll provide you with the exact output.

Right - does it make sense to teach clamav about pread() ?

