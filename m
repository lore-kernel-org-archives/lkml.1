Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYAIVVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYAIVVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYAIVVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:21:01 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35503 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbYAIVVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:21:00 -0500
To: andi@firstfloor.org, harvey.harrison@gmail.com
CC: jdike@addtoit.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <p734pdmput0.fsf@bingen.suse.de> (message from Andi Kleen on Wed,
	09 Jan 2008 22:12:43 +0100)
Subject: Re: uml and -regparm=3
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <p734pdmput0.fsf@bingen.suse.de>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jan 2008 22:20:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > FASTCALL is defined empty in -mm, but UML is not compiled with
> > -mregparm=3 and so this breaks things (I noticed problems with
> > rwsem_down_write_failed).
> >
> > Tried recompiling UML with -mregparm=3, but that resulted in a strange
> > failure immediately after startup:
> >
> > |%Gï¿½%@: Invalid argument
> >
> > What's up?
> 
> UML links with glibc and that does not use -mregparm. 
> 
> You can only use -mregparm in user space if you recompile
> all libraries too.

Ah, right.  I didn't think of that.

Does that mean that FASTCALL removals will have to be undone?  Or is
there an alternative?

Miklos
