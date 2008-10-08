Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYJHTaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYJHTaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYJHTaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:30:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39919 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbYJHTaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:30:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: ksoftirqd accounting broken in 2.6.27-rc9
Date: Wed, 8 Oct 2008 21:34:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20081008173757.GA24560@one.firstfloor.org>
In-Reply-To: <20081008173757.GA24560@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810082134.28345.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 8 of October 2008, Andi Kleen wrote:
> On one test box running 2.6.27rc9 for a few hours I got:
> 
>   PID TTY      STAT   TIME COMMAND
>     1 ?        Ss     0:01 init [3]  
>     2 ?        S<     0:00 [kthreadd]
>     3 ?        S<     0:00 [migration/0]
>     4 ?        S<     0:00 [ksoftirqd/0]
>     5 ?        S<     0:00 [watchdog/0]
>     6 ?        S<     0:00 [migration/1]
>     7 ?        S<     0:00 [ksoftirqd/1]
>     8 ?        S<     0:00 [watchdog/1]
>     9 ?        S<     0:00 [migration/2]
>    10 ?        S<   21133795:38 [ksoftirqd/2]
> ...
>    19 ?        S<   21133795:38 [ksoftirqd/5]
> ...
>    25 ?        S<   21133795:38 [ksoftirqd/7]
> 
> The other kernel threads seem to have correct accounting.

It looks like http://bugzilla.kernel.org/show_bug.cgi?id=11209, doesn't it?

Rafael

