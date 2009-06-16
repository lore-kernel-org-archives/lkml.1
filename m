Return-Path: <linux-kernel-owner+w=401wt.eu-S1765030AbZFPFqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765030AbZFPFqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbZFPFqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:46:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:41720 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbZFPFqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:46:03 -0400
Date: Mon, 15 Jun 2009 22:46:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] WARN(): add a \n to the message printk
Message-ID: <20090615224628.7b0f096c@infradead.org>
In-Reply-To: <alpine.LFD.2.01.0906152055580.3282@localhost.localdomain>
References: <20090615000822.6e6bf282@infradead.org>
	<alpine.LFD.2.01.0906150933330.3305@localhost.localdomain>
	<alpine.LFD.2.01.0906150945490.3305@localhost.localdomain>
	<20090615171044.GC25760@elte.hu>
	<alpine.LFD.2.01.0906152055580.3282@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 21:04:25 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> And no, this does not necessarily fix Arjan's problem: it only adds
> the newline before printk's that _do_ have a KERN_<lvl> format. So
> now, in order to get the extra '\n' after the WARN_ON() line,
> somebody needs to make sure that the printk's in the warning printing
> have loglevels.
> 
> Arjan?
> 

I liked the first patch more :-) ... but practical considerations make
this one more useful I suppose. I'll make the warnings work.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
