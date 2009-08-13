Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZHMJH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZHMJH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZHMJHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:07:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58135 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZHMJHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:07:55 -0400
Date: Thu, 13 Aug 2009 11:07:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Martin-=C9ric?= Racine <q-funk@iki.fi>,
       Alexander Viro <viro@ftp.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13941] x86 Geode issue
Message-ID: <20090813090743.GA14352@elte.hu>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.UBD.ej1fKB@chimera> <11fae7c70908130152j21f9f183m4f1c49d91fc7a7f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11fae7c70908130152j21f9f183m4f1c49d91fc7a7f9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin-Éric Racine <q-funk@iki.fi> wrote:

> Yes, this bug is still valid.
> 
> Ubuntu kernel team member Leann Ogasawara and I are slowly 
> bisecting our way through the changes that took place since 2.6.30 
> to find the commit that introduced this regression. Please stay 
> tuned.

hm, the only outright Geode related commit was:

 d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure

the jpg at:

  http://launchpadlibrarian.net/28892781/00002.jpg

is very out of focus - but what i could decypher suggests a 
pagefault crash in the VFS code, in generic_delete_inode().

Which could be a VFS bug, or a filesystem bug, or some unrelated 
memory corruption hitting the inode data structure.

	Ingo
