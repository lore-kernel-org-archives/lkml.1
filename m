Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbXF0OBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbXF0OBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXF0OBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:01:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:48778 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752890AbXF0OBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:01:33 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1+dWglmy82d3vJAZN+EasJ62YKfKdrB3zo4hQ8fDb
	o4j/bbSHIsmVsn
Message-ID: <46826DBB.8090409@gmx.de>
Date: Wed, 27 Jun 2007 16:01:31 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Johannes Weiner <hannes-kernel@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com
Subject: Re: [BUG] Lockdep warning with XFS on 2.6.22-rc6
References: <20070626021617.GK989688@sgi.com> <20070626093520.GB2691@ff.dom.local> <20070626125006.GG31489@sgi.com>
In-Reply-To: <20070626125006.GG31489@sgi.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch below should fix this (untested).
Just tested 2.6.22-rc6: message is gone when patch is applied. But
deleting some directories in /var/tmp (which lives on xfs) I got:

  BUG: MAX_LOCK_DEPTH too low!
  turning off the locking correctness validator.

Thomas

-- 
keep mailinglists in english, feel free to send PM in german

