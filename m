Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYJNWtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYJNWtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYJNWtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:49:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50793
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbYJNWtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:49:40 -0400
Date: Tue, 14 Oct 2008 15:49:16 -0700 (PDT)
Message-Id: <20081014.154916.232117559.davem@davemloft.net>
To: sven.wegener@stealer.net
Cc: adobriyan@gmail.com, davej@redhat.com, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: Re: sparc64 allmodconfig build failure...
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.0810141434030.13897@titan.stealer.net>
References: <alpine.LNX.2.00.0810140945060.13897@titan.stealer.net>
	<20081014120605.GB23213@x200.localdomain>
	<alpine.LNX.2.00.0810141434030.13897@titan.stealer.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Wegener <sven.wegener@stealer.net>
Date: Tue, 14 Oct 2008 23:08:17 +0200 (CEST)

> Yeah, with the default governor being any of supported governors, we
> either need some ugly #ifdef mess to only export the governor that
> is selected or just revert to the old code, which unconditionally
> exports all governors. Or something like the patch below. With the
> additional modules that I oversaw and that require the export, I'm
> fine with just reverting the commit, although I think that
> encapsulating the default governor decision in a built-in function
> is cleaner than having modules reference different symbols depending
> on configuration.

Personally I prefer the revert.

All of the alternative solutions shown far have been extremely
ugly.
