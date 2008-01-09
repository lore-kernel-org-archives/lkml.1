Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYAIVM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYAIVM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYAIVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:12:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:47718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYAIVMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:12:48 -0500
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: uml and -regparm=3
From: Andi Kleen <andi@firstfloor.org>
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu>
Date: Wed, 09 Jan 2008 22:12:43 +0100
In-Reply-To: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> (Miklos Szeredi's message of "Wed\, 09 Jan 2008 22\:01\:36 +0100")
Message-ID: <p734pdmput0.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> FASTCALL is defined empty in -mm, but UML is not compiled with
> -mregparm=3 and so this breaks things (I noticed problems with
> rwsem_down_write_failed).
>
> Tried recompiling UML with -mregparm=3, but that resulted in a strange
> failure immediately after startup:
>
> |%G�%@: Invalid argument
>
> What's up?

UML links with glibc and that does not use -mregparm. 

You can only use -mregparm in user space if you recompile
all libraries too.

-Andi
