Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZA0VXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZA0VXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZA0VWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:22:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:47929 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZA0VWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:22:53 -0500
Date: Tue, 27 Jan 2009 13:22:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Anderson <anderson@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       crash-utility@redhat.com, Mike Snitzer <snitzer@gmail.com>
Subject: Re: BISECTED: Re: source line numbers with x86_64 modules?
Message-ID: <20090127132239.7087b2f9@infradead.org>
In-Reply-To: <1457226967.823651233090019084.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
References: <952123357.823421233089955989.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
	<1457226967.823651233090019084.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 16:00:19 -0500 (EST)
Dave Anderson <anderson@redhat.com> wrote:
> 
> Actually it's not a problem with the vmlinux file, but rather with
> kernel module object files.  The crash utility has an embedded gdb
> module which is invoked as "gdb vmlinux", and to get line numbers,
> the crash utility simply uses the relevant built-in gdb function to
> get them.  And line numbers work fine with the base kernel code from
> the vmlinux file.


if the entire goal is to get a pinpoint of where the crash is, just
using scripts/markup_oops.pl will do the right thing.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
