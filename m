Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZCDIek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZCDIek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZCDIeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:34:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:51209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZCDIeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:34:31 -0500
Subject: Re: 32bit panic on 4 sockets
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <86802c440903032257l6607972dqe2390958b18454bd@mail.gmail.com>
References: <86802c440903031458p4a72f8c8x6f91e9f58ac6bc26@mail.gmail.com>
	 <86802c440903031751y136b506uc163dd2c9023de9b@mail.gmail.com>
	 <49ADE201.7010506@kernel.org>
	 <86802c440903032257l6607972dqe2390958b18454bd@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 09:34:19 +0100
Message-Id: <1236155659.5330.6837.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 22:57 -0800, Yinghai Lu wrote:
> On Tue, Mar 3, 2009 at 6:05 PM, Tejun Heo <tj@kernel.org> wrote:
> > Looks like a genuine bootmem bug.  Cc'ing Johannes and
> > quoting whole body.
> 
> it is x86 32bit numa code problem. it assume bootmem will sit on first
> node only.

Seems a bit daft to run a 32bit kernel on such a machine.. at some point
we should just give up and not push this 32 bit madness any further.

