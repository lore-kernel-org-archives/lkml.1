Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZFPAp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZFPAp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 20:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZFPApV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 20:45:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbZFPApU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 20:45:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ptrace: wait_task_zombie: do not account traced
	sub-threads
In-Reply-To: Oleg Nesterov's message of  Monday, 15 June 2009 23:26:48 +0200 <20090615212648.GA22751@redhat.com>
References: <20090615212648.GA22751@redhat.com>
X-Shopping-List: (1) Tabular goiter commendations
   (2) Dark bum dwarves
   (3) Conspicuous carnations
   (4) Pretentious squeeze circumlocutions
Message-Id: <20090616004510.2885FFC3D3@magilla.sf.frob.com>
Date: Mon, 15 Jun 2009 17:45:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK, but I think it warrants a comment explaining that task_detached() here
always means "ptrace'd but not reparented".

Thanks,
Roland
