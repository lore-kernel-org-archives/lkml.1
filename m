Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbXLQQHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbXLQQHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932139AbXLQQHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:07:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbXLQQHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:07:41 -0500
Message-ID: <47669E87.1010506@redhat.com>
Date: Mon, 17 Dec 2007 11:06:31 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [-mm][PATCH 0/6] (yet another) kprobes x86 code unification and boosters
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I developed a series of patches which unifies kprobes code on x86
and introduces boosters on x86-64. These patches can be applied to 2.6.24-rc4-mm1.

The purpose of this patchset is unifying kprobes_[32|64].[c|h] to kprobes.[c|h]
for simplifying code maintenance.

I know these patches are conflicting with Harvey's patch.
We need to solve that.

kprobe-booster and kretprobe-booster were explained in:
http://marc.info/?l=linux-kernel&m=113862526017068&w=2

Currently, these patches do unification as following order.
1. Clean up and fix bugs in kprobes[1/6, 2/6].
2. Introduce kprobe-booster and kretprobe-booster for x86-64[3/6, 4/6].
   (x86-32 kprobes already has same functionalities)
3. Prepare unification[5/6].
4. Unify kprobes code[6/6].

If you have any comment, please let me know.


Best Regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


