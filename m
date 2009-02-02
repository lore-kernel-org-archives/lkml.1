Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZBBSNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZBBSNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZBBSNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:13:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:53801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZBBSNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:13:36 -0500
Subject: Re: [git-pull -tip] fix headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
In-Reply-To: <4987321A.1020404@zytor.com>
References: <1233593765.3244.14.camel@localhost.localdomain>
	 <20090202172159.GA7479@localhost>
	 <1233595855.28370.1.camel@localhost.localdomain>
	 <4987321A.1020404@zytor.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 23:42:49 +0530
Message-Id: <1233598369.10133.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 09:49 -0800, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
> >>
> >> Hi Jaswinder,
> >>
> >> it seems we have a clash here :) I thought this part
> >> was just dropped out
> >>
> >> 	http://lkml.org/lkml/2009/1/14/461
> >>
> >> and Peter had been applying it on tip:x86/header-fixes
> >>
> >> 	http://lkml.org/lkml/2009/1/14/549
> >>
> >> but maybe it's just lost...
> > 
> > No, you cannot remove sys_arch_prctl otherwise you will get sparse
> > warning like this:
> > 
> >   CHECK   arch/x86/kernel/process_64.c
> > arch/x86/kernel/process_64.c:833:6: warning: symbol 'sys_arch_prctl' was not declared. Should it be static?
> > 
> 
> Perhaps we can just move this prototype to <asm/syscalls.h>.
> 

fixed and send git pull V2.

--
JSR

