Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203Ab0AVQnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0AVQnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052Ab0AVQnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:43:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0AVQnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:43:49 -0500
Date: Fri, 22 Jan 2010 11:42:48 -0500
From: Jason Baron <jbaron@redhat.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
	analyzing lock statistics
Message-ID: <20100122164248.GA2651@redhat.com>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 10:39:01PM +0900, Hitoshi Mitake wrote:
> Adding new subcommand "perf lock" to perf.
> 

looks like a really intresting patch! Does this patch mean that we can
potentially remove CONFIG_LOCK_STAT, now that the functionality is
available via 'perf'? Another desire for me has been to able to run
lockstat on production box. This has not been possible before without
incurring the performance penalty of lockdep. however, with 'perf' tools
ability to be turned on an off, perhaps there is (or we can build) a
mode for lockdep that is lower overhead for this usecase?

thanks,

-Jason
