Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZFSRYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZFSRYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 13:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZFSRYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 13:24:47 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:58829 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZFSRYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 13:24:46 -0400
Date: Fri, 19 Jun 2009 22:54:41 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch 0/3] ksym_tracer: Improvements, bug-fixes and documentation
	for ksym tracer
Message-ID: <20090619172441.GA26071@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,
	Please find a new set of patches over the ksym tracer in ftrace with
the purpose as defined below.
They are based off commit ce46441b95bcde36649a17d053dc7dc76272f539 in -tip tree.

Patch 1/3: Eliminates the trace concatenation seen after a symbol removal in
ksym tracer. Fixes the previously reported machine stall issue.
Patch 2/3: Improves the input to ksym tracer by allowing removal of all requests
in ksym tracer through single command of empty or wild-card strings.
Patch 3/3: Usage guidelines for ksym tracer brought in through a documentation
patch in Documentation/trace/ksym_tracer.txt

Kindly accept them to be a part of -tip tree.

Thanks,
K.Prasad

