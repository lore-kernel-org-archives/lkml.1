Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYE3Eig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYE3Eig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYE3Ehe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:37:34 -0400
Received: from sslsrv.de ([62.75.159.123]:48829 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYE3Ehc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:37:32 -0400
Message-ID: <18740.193.171.152.33.1212122228.squirrel@webmail.marek.priv.at>
In-Reply-To: <20080529182510.GA15712@uranus.ravnborg.org>
References: <200805291933.54529@marek.priv.at>
    <20080529182510.GA15712@uranus.ravnborg.org>
Date: Fri, 30 May 2008 06:37:08 +0200 (CEST)
Subject: Re: [patch] removes casting of (void*) private structure members
From: "Philipp Marek" <philipp@marek.priv.at>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-4.fc1.1.legacy
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

you wrote:
> Sample from your patch:
...
> Therefore the cast is legitimate.
>
> And I expect gcc to emit:
> warning: assignment makes pointer from integer without a cast
Possibly mine didn't ... I'm getting some build errors related to static
variables being initialized via htonl(), but I did a compile run with this
patch.

I think I used a clean kernel for testing - but maybe I was in the tree
where I tested converting some "unsigned long priv;" to "void*", looking
for problems - as I wrote:
> > There are some private structure variables that are not defined as
> > (void*), (but int or long) and cannot be done without a
> > cast; examples in
> >   drivers/char/hw_random/intel-rng.c
...
> > Should these be converted to (void*), and an additional
> > patch supplied?
If I do a patch for them, can that be a trivial patch, or should I send
each type conversion to the maintainer?


Regards,

Phil

