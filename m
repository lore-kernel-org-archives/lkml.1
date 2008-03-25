Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYCYOQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYCYOQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYCYOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:16:15 -0400
Received: from khc.piap.pl ([195.187.100.11]:51859 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbYCYOQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:16:15 -0400
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
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 25 Mar 2008 15:16:13 +0100
In-Reply-To: <87r6dzi0mw.fsf@basil.nowhere.org> (Andi Kleen's message of "25 Mar 2008 11\:00\:39 +0100")
Message-ID: <m3fxuedh3m.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> It would be fine to allow this unconditionally if there was some mechanism
> to make sure someone else takes over reaping childs while init is
> ptraced.

Well, I think it isn't even necessary, unless you ptrace init for a
long time. I would simply go with the simple 1-line patch.

> I like the general idea -- i used to patch kernels to allow this too,
> but it is dangerous.

Though root-only. Root doesn't want to be limited and knows better
anyway. I think ptracing init is useful even when no one takes care
of the dead (especially if you want to trace waits).
-- 
Krzysztof Halasa
