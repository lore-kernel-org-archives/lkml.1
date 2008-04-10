Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYDJEYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYDJEYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 00:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYDJEXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 00:23:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53435 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYDJEXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 00:23:54 -0400
Date: Thu, 10 Apr 2008 13:23:51 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 00/17] Text Edit Lock and Immediate Values for 2.6.25-rc8-mm1
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20080409150829.855195878@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca>
Message-Id: <20080410125210.231C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu

> Here is the complete patchset required to get basic Immediate Values support
> ported to 2.6.25-rc8-mm1. It provides the "simple", non nmi-safe version of
> immediate values, which means that immediate values should not be used in code
> paths reachable by NMI or MCE handlers. This version also uses
> stop_machine_run() for immediate values updates, which is a very heavy lock.  In
> order to make incremental, easy to review, changes, I think we could start by
> this "simple" version as a first step before we switch to the nmi-safe version
> later.

I think this patch is marker performance improvement infrastructure, right?
if so, I will help debug and testing.

at least, I like this patch series :)



