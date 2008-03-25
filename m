Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYCYKBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYCYKBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYCYKA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:00:58 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:42690 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYCYKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:00:58 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, ebiederm@xmission.com, xemul@openvz.org,
       pavel@ucw.cz, sds@tycho.nsa.gov, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
References: <20080323135110.GA294@tv-sign.ru>
	<20080324152906.dee7b272.akpm@linux-foundation.org>
	<20080324225611.GA157@tv-sign.ru>
	<20080324160819.cea2d921.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 11:00:39 +0100
In-Reply-To: <20080324160819.cea2d921.akpm@linux-foundation.org>
Message-ID: <87r6dzi0mw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 09:54:01.0986 (UTC) FILETIME=[27713620:01C88E5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> Why not just unconditionally enable root's abiltiy to ptrace init?

It would be fine to allow this unconditionally if there was some mechanism
to make sure someone else takes over reaping childs while init is ptraced.

I like the general idea -- i used to patch kernels to allow this too,
but it is dangerous.

-Andi
