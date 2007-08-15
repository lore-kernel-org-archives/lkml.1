Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbXHONJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbXHONJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbXHONJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:09:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122AbXHONJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:09:33 -0400
Date: Wed, 15 Aug 2007 16:03:39 +0200
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       glommer@gmail.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 21/25][V3] export cpu_gdt_descr
Message-ID: <20070815140339.GG3406@bingen.suse.de>
References: <11871823151789-git-send-email-gcosta@redhat.com> <11871823273810-git-send-email-gcosta@redhat.com> <11871823373106-git-send-email-gcosta@redhat.com> <11871823673236-git-send-email-gcosta@redhat.com> <11871823782610-git-send-email-gcosta@redhat.com> <11871823892519-git-send-email-gcosta@redhat.com> <11871823991803-git-send-email-gcosta@redhat.com> <11871824081337-git-send-email-!gcosta@redhat.com> <11871824192375-git-send-email-gcosta@redhat.com> <11871824292046-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11871824292046-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_PARAVIRT
> +extern unsigned long *cpu_gdt_descr;

No externs in .c files

Normally they should be where the variable is defined
anyways.

-Andi
