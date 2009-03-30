Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbZC3EOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbZC3EOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZC3EOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:14:07 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51326 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZC3EOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:14:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18896.18181.14942.461939@cargo.ozlabs.ibm.com>
Date: Mon, 30 Mar 2009 15:13:57 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 7/9] perf_counter: make it possible for hw_perf_counter_init to return error codes
In-Reply-To: <20090328194930.068036716@chello.nl>
References: <20090328194359.426029037@chello.nl>
	<20090328194930.068036716@chello.nl>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$SUBJECT patch has a bug; it doesn't recognize when
hw_perf_counter_init returns an error on a raw hardware event.  I'll
post a new version.

Paul.
