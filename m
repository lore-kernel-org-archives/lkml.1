Return-Path: <linux-kernel-owner+w=401wt.eu-S940440AbXHJQGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940440AbXHJQGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939553AbXHJQFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:05:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36144 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938883AbXHJQFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:05:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC3CB1.2090503@googlemail.com> <46BC45FA.7060305@googlemail.com>
Date: Fri, 10 Aug 2007 10:05:12 -0600
In-Reply-To: <46BC45FA.7060305@googlemail.com> (Gabriel C.'s message of "Fri,
	10 Aug 2007 13:03:22 +0200")
Message-ID: <m1sl6rxtmv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C <nix.or.die@googlemail.com> writes:

> And this 2
>
> ...
> [ 30.046491] sysctl table check failed: /kernel/cad_pid .1.54 Missing strategy
> [   30.046527] sysctl table check failed: /kernel/pty/nr .1.62.2 No data
> ...

Yep.

The cad_pid case seems to be a real bug.
The pty/nr is a race you can't exploit in practice. 

I haven't gotten to either of those yet.

Eric

