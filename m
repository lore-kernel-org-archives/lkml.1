Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbZDBSxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbZDBSxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbZDBSwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:52:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:59787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423AbZDBSwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:52:53 -0400
Subject: Re: [tip:perfcounters/core] perf_counter: kerneltop: update to new
 ABI
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090402182833.GA32407@elte.hu>
References: <20090402091319.407283141@chello.nl>
	 <tip-373b153677f26a263ef297d77a5e045a31f6486c@git.kernel.org>
	 <1238679305.3099.11.camel@ht.satnam> <1238680772.3099.13.camel@ht.satnam>
	 <20090402181144.GB6340@elte.hu> <1238696579.3099.50.camel@ht.satnam>
	 <20090402182833.GA32407@elte.hu>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 00:21:58 +0530
Message-Id: <1238698318.3099.62.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:28 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Thu, 2009-04-02 at 20:11 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > > On Thu, 2009-04-02 at 19:05 +0530, Jaswinder Singh Rajput wrote:
> > > > > On Thu, 2009-04-02 at 12:03 +0000, Peter Zijlstra wrote:
> > > > > > Commit-ID:  373b153677f26a263ef297d77a5e045a31f6486c
> > > > > > Gitweb:     http://git.kernel.org/tip/373b153677f26a263ef297d77a5e045a31f6486c
> > > > > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > > AuthorDate: Thu, 2 Apr 2009 11:12:02 +0200
> > > > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > > > CommitDate: Thu, 2 Apr 2009 13:53:00 +0200
> > > > > > 
> > > > > > perf_counter: kerneltop: update to new ABI
> > > > > > 
> > > > > > Update to reflect the new record_type ABI changes.
> > > > > > 
> > > > > 
> > > > > perfstat is still having many issues:
> > > > > 
> > > > > 1. 0:6: bus-cycles is not valid for AMD, so it fails
> > > > > 

This is the major issue.

bus-cycles is not valid for AMD and it returns error. And I am not able
to find any relevant event for AMD.

How can we suppress this error on AMD Box.

--
JSR

