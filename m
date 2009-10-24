Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZJXBTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZJXBTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZJXBTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:19:14 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:61838 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZJXBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> 
	<20091023210231.GC8356@elte.hu> <1256334501-15755-1-git-send-email-marti@juffo.org> 
	<193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com>
From: Marti Raudsepp <marti@juffo.org>
Date: Sat, 24 Oct 2009 04:18:58 +0300
Message-ID: <54b33ccd0910231818k37f0056bsb528d76b4f515ded@mail.gmail.com>
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and 
	autodetect
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 4:07 AM, Lucas De Marchi
<lucas.de.marchi@gmail.com> wrote:
> Why don't you do something like?:
>
> #ifdef LIBELF_NO_MMAP
> #define ELF_C_READ_MMAP ELF_C_READ
> #endif

Seemed like bad programming practice to redefine enum constants from
third-party include files. But you are right, it would significantly
simplify the patch. Can we get a third opinion?

Marti
