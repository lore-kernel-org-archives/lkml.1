Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbXJ0ElV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbXJ0ElV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 00:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXJ0ElN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 00:41:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60026 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXJ0ElM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 00:41:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kir@swsoft.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, kir@openvz.org,
       Cedric Le Goater <clg@fr.ibm.com>, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>
	<m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>
	<20071027002448.GH30533@stusta.de>
	<m18x5puyw7.fsf@ebiederm.dsl.xmission.com>
	<20071027020408.GO30533@stusta.de>
	<20071026191845.fd0f75c8.akpm@linux-foundation.org>
	<m18x5pte18.fsf@ebiederm.dsl.xmission.com>
	<20071027040346.GQ30533@stusta.de>
Date: Fri, 26 Oct 2007 22:40:12 -0600
In-Reply-To: <20071027040346.GQ30533@stusta.de> (Adrian Bunk's message of
	"Sat, 27 Oct 2007 06:03:46 +0200")
Message-ID: <m14pgdtbkj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> There isn't any hard semantics behind what is marked EXPERIMENTAL and 
> what not. In it's current state, we could even consider removing the 
> EXPERIMENTAL option and all dependencies on EXPERIMENTAL.

Well I do know at least some of the things that depend on experimental
are legitimate.

I wonder if the problem is that we don't police experimental well
enough.

> Currently CONFIG_EXPERIMENTAL=n would cost a distribution a three digit 
> number of device drivers plus several features like e.g. NFSv4.

I can see a distribution carefully cherry picking things, that the
have an intimate knowledge about out of experimental but it doesn't
sound right for taking things out of EXPERIMENTAL to be routine.

I know I'm a little slow about getting around to it but when ever I
have a feature that isn't EXPERIMENTAL anymore I remove the tag.

Eric
