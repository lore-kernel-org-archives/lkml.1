Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXKBAXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXKBAXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbXKBAXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:23:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbXKBAXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:23:36 -0400
Message-ID: <472A6DE7.8060800@redhat.com>
Date: Thu, 01 Nov 2007 17:23:03 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu> <4729E86A.9090705@redhat.com> <20071101150537.GC4044@elte.hu> <20071101185710.GA2387@thunk.org> <20071101195358.GA15636@elte.hu>
In-Reply-To: <20071101195358.GA15636@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:

> but this problem is still present in the code, and it has been recently 
> committed into mainline via:
> 
>   commit 30e49c263e36341b60b735cbef5ca37912549264
>   Author: Pavel Emelyanov <xemul@openvz.org>
>   Date:   Thu Oct 18 23:40:10 2007 -0700
> 
>       pid namespaces: allow cloning of new namespace
> 
> without these problems having been resolved. A full-scale revert is 
> probably too intrusive, but at minimum we need to turn off user-space 
> access to this feature via this simple patch. Until this issue is 
> resolved properly the new PID namespace code needs to be turned off. 
> Letting this into 2.6.24 would be a disaster.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Ulrich Drepper <drepper@redhat.com>


- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHKm3n2ijCOnn/RHQRAn7dAJ9PhfhLg29mTELwH7qLXwgJcyNi9QCgr7sc
WQa4QBNesktzPKh5vcCulhM=
=cYnF
-----END PGP SIGNATURE-----
