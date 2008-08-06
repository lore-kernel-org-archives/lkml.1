Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYHFMl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYHFMl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYHFMls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:41:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:55190 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751829AbYHFMlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:41:47 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18dJi9Sh1kd+j33j461Z3HhNZwNFmeVNiSGfv4v7v
	pDDUFLDrQZ2QYj
Date: Wed, 6 Aug 2008 14:41:34 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com
Subject: Re: Oops when accessing /proc/lockdep_chains
Message-ID: <20080806124134.GA3615@alice>
References: <20080806121650.GA3119@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080806121650.GA3119@alice>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26 (x86_64)
X-Uptime: 14:41:06 up 1 day, 23:23,  1 user,  load average: 0.27, 0.21, 0.31
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Sesterhenn (snakebyte@gmx.de) wrote:
> hi,
> 
> with current -git (aka -rc2) i sometime get the following oops
> when doing a cat /proc/lockdep_chains
> The other /proc/lockdep* files dont cause any errors
> 
> I dont get it after a fresh reboot :| But was able to reproduce it when
> running my testscripts, I'll try to narrow it down.

I can easily reproduce this with

modprobe rcutorture; sleep 10s; rmmod rcutorture; cat
/proc/lockdep_chains > /dev/null

Greetings, Eric
