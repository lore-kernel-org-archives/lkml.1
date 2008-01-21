Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYAUVaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYAUVaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYAUVam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:30:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38269 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYAUVal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:30:41 -0500
Date: Mon, 21 Jan 2008 13:29:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] [RFC] x86: Make page fault oopses similar
Message-ID: <20080121132920.6975077d@laptopd505.fenrus.org>
In-Reply-To: <1200950446.16972.25.camel@brick>
References: <1200950446.16972.25.camel@brick>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2008 13:20:46 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Introduce printk_address to X86_32 in a simplified form for
> now.  Reformat X86_64 printk_address to avoid two declarations.
> 
> Change the printk formats on X86_32 and 64 to be similar.

I'm not entirely convinced on this; I need to look closer but it appears the 32 bit version 
doesn't use the "reliable" argument to print a ? in front of the dubious backtrace entries;
that would be sort of a step backwards; (

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
