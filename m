Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbYETOwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbYETOwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764337AbYETOwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:52:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbYETOwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:52:00 -0400
Date: Tue, 20 May 2008 10:51:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: michael@ellerman.id.au, proski@gnu.org, a.p.zijlstra@chello.nl,
       sandmann@redhat.com, pq@iki.fi, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>,
       paulus@samba.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] ftrace: support for PowerPC
In-Reply-To: <1211293059.8297.166.camel@pasglop>
Message-ID: <Pine.LNX.4.58.0805201051210.2210@gandalf.stny.rr.com>
References: <20080515034942.109223655@goodmis.org>  <20080515035918.896765954@goodmis.org>
  <1211292277.7960.8.camel@localhost> <1211293059.8297.166.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 May 2008, Benjamin Herrenschmidt wrote:

> > Why do we not want to trace early boot? Just because it's not useful?
>
> Not running at the linked address... might be causing trouble.

I figured it was something like that, so I didn't look too deep into it,
and decided that it was best just not to trace it.

-- Steve

