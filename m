Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbZGIH6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbZGIH6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZGIH6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:58:11 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:26612 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZGIH6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:58:10 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 0/2] perf_counter: add tracepoint support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, rostedt@goodmis.org
In-Reply-To: <20090709031032.GA6412@nowhere>
References: <cover.1246912068.git.jbaron@redhat.com>
	 <20090709031032.GA6412@nowhere>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 09:58:03 +0200
Message-Id: <1247126283.9777.318.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 05:10 +0200, Frederic Weisbecker wrote:
> (RFD parenthesis: why not using the one in kernel/trace for all perf events?
> Now that it is lockless, it would fit nicely inside: no fear about NMI
> context).

because that one doesn't have a single-buffer mode you can mmap().

