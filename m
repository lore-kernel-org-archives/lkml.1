Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYAHVAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYAHVAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYAHVAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:00:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:52584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbYAHVAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:00:30 -0500
To: ananth@in.ibm.com
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, Jim Keniston <jkenisto@us.ibm.com>, mhiramat@redhat.com,
       davem@davemloft.net, hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
From: Andi Kleen <andi@firstfloor.org>
References: <20080108063334.GA29385@in.ibm.com>
Date: Tue, 08 Jan 2008 22:00:24 +0100
In-Reply-To: <20080108063334.GA29385@in.ibm.com> (Ananth N. Mavinakayanahalli's message of "Tue\, 8 Jan 2008 12\:03\:34 +0530")
Message-ID: <p73zlvgowwn.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli <ananth@in.ibm.com> writes:
>  kernel/kprobes.c        |    2 
>  kernel/test_kprobes.c   |  216 ++++++++++++++++++++++++++++++++++++++++++++++++

Can you put this somewhere else please? I know there are already some
test files in kernel/* but imho they all belong into some other directory.

+	if (!err)
+		init_test_probes();
 	return err;

Couldn't this be just a normal initcall? Perhaps even a module_init(),
then it would be possible to use as a module too.

-Andi
