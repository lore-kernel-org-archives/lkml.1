Return-Path: <linux-kernel-owner+w=401wt.eu-S939062AbXHJPKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939062AbXHJPKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXHJPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:10:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbXHJPJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:09:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "jidong xiao" <jidong.xiao@gmail.com>
Subject: Re: Question about PF_NOFREEZE
Date: Fri, 10 Aug 2007 17:19:27 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <4104961b0708092219r6fbc5854pc41a4a98a2b79c2a@mail.gmail.com>
In-Reply-To: <4104961b0708092219r6fbc5854pc41a4a98a2b79c2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708101719.27558.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 August 2007 07:19, jidong xiao wrote:
> if one thread set its current->flag with PF_NOFREEZE, then it means
> this thread is unfreezable,does this mean, when the system entered
> into a suspended state, even though all the other threads have already
> gone sleep, this thread still keeps awaken?

It will be able to run when all freezable threads are frozen.

> One thing I am very confused is, if all the other threads goes to
> sleep,can this only one thread(assume only one thread marked itself as
> unfreezable.) still works well?

The question is rather theoretical, because there are some unfreezable threads
in the system.  In theory, such a thread can work well as long as it doesn't
need to wait for another thread that is frozen.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
