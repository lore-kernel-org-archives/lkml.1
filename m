Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZEDSuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZEDSuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZEDSup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:50:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZEDSuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:50:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/utrace
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
In-Reply-To: Oleg Nesterov's message of  Sunday, 3 May 2009 20:55:37 +0200 <20090503185537.GA17071@redhat.com>
References: <20090503185537.GA17071@redhat.com>
X-Shopping-List: (1) Elevated detention
   (2) Inquisitive annoyer revulsion
   (3) Erratic cushions
   (4) Circular contraptions
Message-Id: <20090504184951.623CEFC32F@magilla.sf.frob.com>
Date: Mon,  4 May 2009 11:49:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess I'm slightly confused.  We want to merge all of the "pure" ptrace
cleanup patches before any utrace patch.  When those are on their way,
we'll update the utrace patches not to conflict.  I don't think it makes
sense to include utrace.patch's little ptrace.c change in the baseline tree
for your ptrace cleanup patches.


Thanks,
Roland
