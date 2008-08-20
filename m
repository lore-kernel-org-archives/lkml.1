Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYHTJ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYHTJ7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYHTJ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:59:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49237 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYHTJ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:59:35 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Greg Donald" <gdonald@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: INFO: task reiserfs/0:1322 blocked for more than 120 seconds
From: Andi Kleen <andi@firstfloor.org>
References: <15e66e4e0808162136r2a439ee9wbb20f2b1f8fabc77@mail.gmail.com>
	<20080819235258.fa775505.akpm@linux-foundation.org>
Date: Wed, 20 Aug 2008 11:59:32 +0200
In-Reply-To: <20080819235258.fa775505.akpm@linux-foundation.org> (Andrew Morton's message of "Tue, 19 Aug 2008 23:52:58 -0700")
Message-ID: <87ej4kypkr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Seems that about 100% of the reports we get of this warning triggering
> are sys_sync, transaction commit, etc.

And NFS -- i just had the kernel log on one of my nfsroot test systems
flooded recently with them when the ethernet cable was disconnected
for some time and nfs blocked.  Scared me first, but then after
analysis didn't seem very useful. I imagine it would scare normal
users far more.

-Andi
