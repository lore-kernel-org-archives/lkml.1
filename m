Return-Path: <linux-kernel-owner+w=401wt.eu-S1761726AbZLLK4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761726AbZLLK4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZLLK4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:56:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbZLLK4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:56:04 -0500
Date: Sat, 12 Dec 2009 11:55:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf bench: Add "all" pseudo subsystem and "all" pseudo
 suite
Message-ID: <20091212105554.GA9345@elte.hu>
References: <20091124152051.GA21821@elte.hu>
 <1260614277-6059-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260614277-6059-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> | # Running mem/memcpy benchmark...             # Second mem !?
> | # Copying 1MB Bytes from 0x7ff33e920010 to 0x7ff3401ae010 ...
> |
> |      841.042893 MB/Sec
> 
> mem subsystem was executed twice!

i saw something similar some time ago but thought it got fixed. Maybe 
some fork() related trouble?

	Ingo
