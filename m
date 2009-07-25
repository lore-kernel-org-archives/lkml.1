Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZGYWzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZGYWzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 18:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZGYWzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 18:55:10 -0400
Received: from mail2.shareable.org ([80.68.89.115]:60510 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZGYWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 18:55:10 -0400
Date: Sat, 25 Jul 2009 23:54:59 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Subject: Re: report a bug about sched_rt
Message-ID: <20090725225459.GB15260@shareable.org>
References: <1248441290.6987.52.camel@twins> <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com> <1248442415.6987.56.camel@twins> <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com> <1248443656.6987.61.camel@twins> <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com> <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org> <1248451279.6987.138.camel@twins> <1248524354.8429.100.camel@Palantir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248524354.8429.100.camel@Palantir>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raistlin wrote:
> >   http://feanor.sssup.it/~faggioli/papers/OSPERT-2009-dlexception.pdf
>
> It is probably not always the best way of doing, but it's something we
> think it could be useful somewhere. Therefore, we are still working on
> it, e.g., improving timer resolution, adding the support for new
> semantic and programming models, etc. Moreover, we are open to any
> suggestion and contribution about this work, especially from the
> community!

The biggest weakness I see is if the application has a bug such as
overwriting random memory or terminating the thread which is receiving
timer signals, it can easily break the scheduling policy by accident.

When the scheduling policy is implemented in the kernel, it can only
be broken by system calls requesting a change of scheduling policy,
which are relatively unlikely, and if necessary that can be completely
prevented by security controls.

-- Jamie
