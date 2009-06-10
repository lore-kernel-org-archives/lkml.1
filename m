Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbZFJN3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbZFJN3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZFJN3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:29:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:53964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbZFJN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:29:22 -0400
Subject: RE: [tip:tracing/core] x86, bts: reenable ptrace branch trace
 support
From: Peter Zijlstra <peterz@infradead.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "mingo@redhat.com" <mingo@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EBBC651E2@irsmsx504.ger.corp.intel.com>
References: <20090424094448.A30216@sedona.ch.intel.com>
	 <tip-7e0bfad24d85de7cf2202a7b0ce51de11a077b21@git.kernel.org>
	 <1244637843.13761.11786.camel@twins> <20090610125108.GA13506@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EBBC651E2@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Jun 2009 15:29:18 +0200
Message-Id: <1244640558.13761.11833.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 14:22 +0100, Metzger, Markus T wrote:
> 
> The Debug Store interface is completely in-kernel. It does not expose
> anything to the outside world.
> 
> What we expose is a ptrace interface for branch tracing.
> That this is built on top of Debug Store is completely hidden.
> The Debug Store interface may be changed without impacting the
> user-visible part at any time.
> 
> I do think that a ptrace interface makes sense since debuggers are the
> targeted users for branch tracing.
> 
> I don't see why we should not merge the fixes now and then rework the
> in-kernel parts as needed for supporting PEBS.

Ok, so what is all that account_locked_memory() for?
