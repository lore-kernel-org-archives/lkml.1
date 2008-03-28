Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYC1Ah4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYC1Ah4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYC1Ahr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:37:47 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38767 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753105AbYC1Ahr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:37:47 -0400
Date: Thu, 27 Mar 2008 17:35:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3 of 4] sparsemem: reduce i386 PAE section size
In-Reply-To: <b7d0773c79887ca98d6c.1206664119@localhost>
Message-ID: <Pine.LNX.4.64.0803271734450.10635@schroedinger.engr.sgi.com>
References: <b7d0773c79887ca98d6c.1206664119@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Jeremy Fitzhardinge wrote:

> A 1G section size makes memory hotplug too coarse in a virtual
> environment.  Retuce it by a factor of 2 to 512M.  I would have liked
> to make it smaller, but it runs out of reserved flags in the page flags.

There are patches in mm which changes that situation. You should have 5 or 
6 more flags to play with.

