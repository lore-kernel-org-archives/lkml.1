Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZFDNOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZFDNOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZFDNOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:14:10 -0400
Received: from verein.lst.de ([213.95.11.210]:54537 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZFDNOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:14:09 -0400
Date: Thu, 4 Jun 2009 15:14:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: types for storing instruction pointers
Message-ID: <20090604131400.GA31596@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the _THIS_IP_ and _RET_IP_ macros aded for lockdep but now
available from kernel.org case the instruction pointer to an unsigned
long.  But the %pf/%pF format for printing them want a pointer of some
sort.  That's a pretty nasty situation for tracers - can we standardize
on one type for it?
