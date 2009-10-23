Return-Path: <linux-kernel-owner+w=401wt.eu-S1752271AbZJWPJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbZJWPJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZJWPJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:09:44 -0400
Received: from fifo99.com ([67.223.236.141]:60275 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZJWPJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:09:44 -0400
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI
 table is present
From: Daniel Walker <dwalker@fifo99.com>
To: Erwan Velu <erwanaliasr1@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <4AE1C5C6.7000103@gmail.com>
References: <4AE178AF.3010804@gmail.com> <20091023110323.GC10071@elte.hu>
	 <4AE19867.5070705@gmail.com> <1256302066.10493.74.camel@desktop>
	 <4AE1C5C6.7000103@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Oct 2009 08:09:36 -0700
Message-Id: <1256310576.10493.78.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 17:03 +0200, Erwan Velu wrote:
> Daniel Walker a écrit :
> > [...]
> > It's your defect, so you can still try to fix it (unless the "xen
> > people" or someone else beats you to it.) 
> >
> > It looks like on a normal system dmi_scan_machine() gets called very
> > early in setup_arch() arch/x86/kernel/setup.c . A possible good fix
> > might be to add a dmi_disable() into the dmi driver that just shuts off
> > dmi, and run that in xen_arch_setup() in arch/x86/xen/setup.c 
> Could it make sense having this patch (I can work on it) while keeping 
> my previous patch ?
> Does it make sense keeping the default return value I've been adding 
> when no dmi table is found ?

Ingo mentioned that the returning mechanism your adding was left out
intentionally to catch this error, so I don't think your original patch
could be included .. 

Daniel

