Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbZDQR2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbZDQR2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbZDQR2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:28:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:51241 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbZDQR17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:27:59 -0400
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49E8BB98.3090901@goop.org>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
	 <20090414153035.C662.A69D9226@jp.fujitsu.com>
	 <20090414065303.GA24626@elte.hu>  <49E8BB98.3090901@goop.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 19:27:40 +0200
Message-Id: <1239989260.23397.4848.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 10:25 -0700, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > We could zap all pending trace entries on module unload (it is a 
> > rare operation)
> 
> ....Unless you're trying to trace something across a module unload.  I 
> don't know if its at all practical, but it would be nice to just zap the 
> pointers within the buffer, rather than the whole buffer.

I think the new __string() thing that's in the works will avoid the
whole problem by copying the string into the buffer, instead of keeping
a reference.

