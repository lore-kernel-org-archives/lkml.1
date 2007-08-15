Return-Path: <linux-kernel-owner+w=401wt.eu-S1764829AbXHOO0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764829AbXHOO0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764576AbXHOOZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:25:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:16257 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764425AbXHOOZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mWdDQim7lYBtOgpKVi4AA2nuWtIOMwWj6sxc6pePNOJm7qj+Nb+QuHhDI1DJfpiP04PzBCZFcHPvObvaRgWr36jSMybFPyc0eWjVy3L3q+aG/LQotfcDngoQfANrIoXAHKWBBK3paf+EjJFfseYNlxVUcBJyjIVe7BaHpm53wJE=
Message-ID: <5d6222a80708150725i45a064bfqfd43139338287988@mail.gmail.com>
Date: Wed, 15 Aug 2007 11:25:43 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 21/25][V3] export cpu_gdt_descr
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20070815140339.GG3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11871823151789-git-send-email-gcosta@redhat.com>
	 <11871823373106-git-send-email-gcosta@redhat.com>
	 <11871823673236-git-send-email-gcosta@redhat.com>
	 <11871823782610-git-send-email-gcosta@redhat.com>
	 <11871823892519-git-send-email-gcosta@redhat.com>
	 <11871823991803-git-send-email-gcosta@redhat.com>
	 <11871824081337-git-send-email-!gcosta@redhat.com>
	 <11871824192375-git-send-email-gcosta@redhat.com>
	 <11871824292046-git-send-email-gcosta@redhat.com>
	 <20070815140339.GG3406@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/07, Andi Kleen <ak@suse.de> wrote:
> > +#ifdef CONFIG_PARAVIRT
> > +extern unsigned long *cpu_gdt_descr;
>
> No externs in .c files
>
> Normally they should be where the variable is defined
> anyways.
Given that this  variable is defined in head.S, what do you propose?
AFAICT, this is the very duty of this file (x8664_syms.c), and the
extern is also used in other symbols like the memcpy family

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
