Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZGAHj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZGAHj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZGAHjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:39:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZGAHjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:39:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 3/3] elf: use a macro instead of a raw number
In-Reply-To: Amerigo Wang's message of  Wednesday, 1 July 2009 01:06:46 -0400 <20090701050900.6188.41697.sendpatchset@localhost.localdomain>
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
	<20090701050900.6188.41697.sendpatchset@localhost.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090701073810.A80FC21D57@magilla.sf.frob.com>
Date: Wed,  1 Jul 2009 00:38:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use TASK_COMM_LEN instead of the raw number 16.

This is probably a bad idea.  elf_prpsinfo layout is a userland ABI.
AFAIK there is no reason TASK_COMM_LEN could not be enlarged in the kernel.


Thanks,
Roland
