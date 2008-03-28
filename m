Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbYC1GTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbYC1GTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 02:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYC1GTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 02:19:17 -0400
Received: from gw.goop.org ([64.81.55.164]:56339 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbYC1GTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 02:19:16 -0400
Message-ID: <47EC8DD0.4090401@goop.org>
Date: Thu, 27 Mar 2008 23:18:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3 of 4] sparsemem: reduce i386 PAE section size
References: <b7d0773c79887ca98d6c.1206664119@localhost> <Pine.LNX.4.64.0803271734450.10635@schroedinger.engr.sgi.com> <47EC574C.10006@goop.org> <Pine.LNX.4.64.0803271926520.11576@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0803271926520.11576@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Only works on i386 if you either use sparsemem / vmemmap or not sparsemem 
> though. Is there any need for the other sparsemem memory models? Or could 
> we disable them like on x86_64?

Probably, but I don't know what the tradeoffs are.  All I want is 
hotplug memory.

    J

