Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189Ab0ARHUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0ARHUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470Ab0ARHUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:20:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0ARHUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:20:45 -0500
Subject: Re: [PATCH 0/5] lockdep: Add information of file and line to
 lockdep_map
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <4B51B8A4.7010503@dcl.info.waseda.ac.jp>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
	 <1262860795-5745-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1263376323.4244.204.camel@laptop> <4B51B8A4.7010503@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 08:20:19 +0100
Message-ID: <1263799219.4283.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 22:01 +0900, Hitoshi Mitake wrote:
> 
> And I want lockdep_map to have another thing, type of lock.
> For example, mutex and spinlock has completely different acquired
> time 
> and attributes,
> so I want to separate these things. If lockdep_map has member
> to express type, things will be easy. 

I'm worrying about growing things too much.. esp. when the gain is
dubious. People will see the type soon enough when they go look at the
code.

