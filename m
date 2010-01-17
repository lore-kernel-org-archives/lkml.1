Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202Ab0AQBXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0AQBXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 20:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110Ab0AQBXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 20:23:54 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38719 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0AQBXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 20:23:53 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Sun, 17 Jan 2010 02:24:35 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1263549544.3112.10.camel@maxim-laptop> <201001162317.39940.rjw@sisk.pl> <201001170138.37283.rjw@sisk.pl>
In-Reply-To: <201001170138.37283.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001170224.36267.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 17. Januar 2010 01:38:37 schrieb Rafael J. Wysocki:
> > Now having said that, we've been considering a change that will turn all
> > GFP_KERNEL allocations into GFP_NOIO during suspend/resume, so perhaps I'll
> > prepare a patch to do that and let's see what people think.
> 
> If I didn't confuse anything (which is likely, because it's a bit late here
> now), the patch below should do the trick.  I have only checked that it doesn't
> break compilation, so please take it with a grain of salt.
> 
> Comments welcome.

I think this is a bad idea as it makes the mm subsystem behave differently
in the runtime and in the whole system cases. What's so hard about telling
people that they need to use GFP_NOIO in suspend() and resume()?

		Regards
		Oliver
