Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbZJMLvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbZJMLvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbZJMLvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233AbZJMLvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:51:11 -0400
Date: Tue, 13 Oct 2009 07:50:36 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Message-ID: <1209036982.100421255434636304.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20091012142328.710881fe.sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the i7core_edac tree with Linus'
 tree
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Stephen Rothwell" <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
> 
> Today's linux-next merge of the i7core_edac tree got a conflict in
> arch/x86/kernel/cpu/mcheck/mce.c between commit
> f436f8bb73138bc74eb1c6527723e00988ad8a8a ("x86: EDAC: MCE: Fix MCE
> decoding callback logic") from Linus' tree and commit
> 699a7dbe1ffdf4b25c1475e45590b181c3e23087 ("edac_mce: Add an interface
> driver to report mce errors via edac") from the i7core_edac tree.
> 
> I don't know how to resolve these two commits so I have dropped the
> i7core_edac tree for today.

Thanks for letting me know. I've rebased it fixing the merge conflict. For now,
I just removed the call to edac_mce_parse() for Uncorrected Errors, since I'll
eventually replace that part of the code with something better.

You should now be able to merge it without merging conflicts.

Cheers,
Mauro.
