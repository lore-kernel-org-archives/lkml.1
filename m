Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYCYO7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYCYO7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYCYO7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:59:01 -0400
Received: from khc.piap.pl ([195.187.100.11]:47464 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbYCYO7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:59:01 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       ebiederm@xmission.com, xemul@openvz.org, pavel@ucw.cz,
       sds@tycho.nsa.gov, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
References: <20080323135110.GA294@tv-sign.ru>
	<20080324152906.dee7b272.akpm@linux-foundation.org>
	<20080324225611.GA157@tv-sign.ru>
	<20080324160819.cea2d921.akpm@linux-foundation.org>
	<87r6dzi0mw.fsf@basil.nowhere.org>
	<m3fxuedh3m.fsf@maximus.localdomain>
	<20080325142259.GO2170@one.firstfloor.org>
	<m37ifqdgfu.fsf@maximus.localdomain>
	<20080325143544.GP2170@one.firstfloor.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 25 Mar 2008 15:58:55 +0100
In-Reply-To: <20080325143544.GP2170@one.firstfloor.org> (Andi Kleen's message of "Tue\, 25 Mar 2008 15\:35\:44 +0100")
Message-ID: <m3y786c0k0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Sure, but if the deadlocks can be avoided on the kernel level (just
> making sure the children are already reaped) then it would be even
> better.

Well, if you mean the kernel would do that unconditionally (thus it
won't be init's job anymore, ptrace or not) then I can only agree.
-- 
Krzysztof Halasa
