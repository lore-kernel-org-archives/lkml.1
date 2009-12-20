Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZLTOwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZLTOwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 09:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZLTOwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 09:52:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:43026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZLTOwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 09:52:17 -0500
Subject: Re: sched: restore sanity
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091220144925.GA19608@elte.hu>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 15:51:55 +0100
Message-ID: <1261320715.4314.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 15:49 +0100, Ingo Molnar wrote:
>  
> > -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> that's all that we need to remove i suspect, to get rid of the stupid 
> prefixes.

Probably, but the rest is just as annoying, pr_* is crap.

