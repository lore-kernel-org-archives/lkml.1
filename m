Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbXJaV7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbXJaV7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbXJaV7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:59:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbXJaV7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:59:08 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com
Subject: [PATCH 0/7] (Re-)introducing pvops for x86_64 - Consolidation part
Date: Wed, 31 Oct 2007 16:13:12 -0300
Message-Id: <1193857999499-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

Here is the result of the latest work on the pvops front, after the x86
arch merge. From the functionality point of view, almost nothing was
changed, except for proper vsmp support - which was discussed, but not
implemented before - and the introduction of smp_ops in x86_64, which eased
the merging of the smp header.

Speaking of the merge, a significant part (although not majority) of this
work is merging things that was not possible before, due to the lack of
paravirt for x86_64. What was done then, can be thought as a
"lookahead-merge", which is a normal code, but just taking into account that
we'll have support for paravirt_ops in x86_64 in the future. Note for that
files, there can be room left for more integration. This is just the first,
not the final step.

For this reason, I'm splitting this series in two. The first one, which will
follow this message, are really just integration patches. Besides making
review even easier, we believe that those could get into the .24 time frame,
just like all the other merge patches that are already going in.

In a separate series, you'll get the actual pvops implementation.

That said, have fun!
