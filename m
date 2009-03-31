Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZCaVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZCaVQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZCaVQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:16:01 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:57799 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbZCaVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:16:00 -0400
Date: Tue, 31 Mar 2009 17:10:40 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
In-Reply-To: <20090331221847.50ea3356@skybase>
Message-ID: <alpine.DEB.1.10.0903311708540.30693@qirst.com>
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325122241.GE11571@elte.hu>
 <49CA2345.70204@kernel.org> <20090325141330.2717dc97@skybase> <49CA2FBF.9000207@kernel.org> <20090325142525.2d31c522@skybase> <49CA32F6.2030408@kernel.org> <20090331185431.72ff1707@skybase> <alpine.DEB.1.10.0903311318300.1912@qirst.com>
 <20090331221847.50ea3356@skybase>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Martin Schwidefsky wrote:

> > Please include the patch inline next time.
>
> What do you mean by "inline"? That the patch should not be the last
> thing in the mail?

The patch needs to show up when I press reply and not vanish. I guess this
was an attachment.

> I don't see how changes to the initial per cpu segment should help with
> access to per cpu symbols.

Can you convince the linker to place the per cpu segment > 4G away from
the code? Its a virtual address right?


