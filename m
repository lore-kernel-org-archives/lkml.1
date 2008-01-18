Return-Path: <linux-kernel-owner+w=401wt.eu-S1763253AbYARQqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763253AbYARQqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbYARQqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:46:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:42152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965AbYARQqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:46:08 -0500
X-ExtLoop1: 1
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Date: Fri, 18 Jan 2008 08:46:02 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <20080118120112.GB8583@elte.hu> <20080118131209.GA16459@one.firstfloor.org>
In-Reply-To: <20080118131209.GA16459@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801180846.03161.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2008 5:12 am Andi Kleen wrote:
> > (AMD machines apparently don't need it
>
> That's not true -- we had AMD systems in the past with broken MTRRs for
> large memory configurations too,  Mostly it was pre revE though.

It should be easy enough to enable it for AMD as well, and it would also be 
good to track down the one failure you found...  I don't *think* the 
re-ordering of MTRR initialization should affect AMDs anymore than it does 
Intel, but someone familiar with the boot code would have to do a quick audit 
to be sure.

Jesse
