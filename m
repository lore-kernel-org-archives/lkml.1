Return-Path: <linux-kernel-owner+w=401wt.eu-S936225AbXHGXQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936225AbXHGXQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbXHGXQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:16:28 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1404 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbXHGXQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:16:27 -0400
Date: Wed, 8 Aug 2007 01:16:49 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <20070807124009.9f6c2247.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708080115020.1817@scrub.home>
References: <15327.1186166232@lwn.net> <20070807124009.9f6c2247.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 7 Aug 2007, Andrew Morton wrote:

> I'd be surprised if there was significant overhead - the maximum frequency
> at which msleep() can be called is 1000Hz.  We'd need an awful lot of
> overhead for that to cause problems, surely?
> 
> <thinks he's missing something again>

_Anybody_ has yet to answer what's wrong with adding a nanosleep() and 
using that instead.

bye, Roman
