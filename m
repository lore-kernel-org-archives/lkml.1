Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYFCWBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYFCWBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYFCWB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:01:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44885 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYFCWB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:01:26 -0400
Date: Wed, 4 Jun 2008 01:01:25 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Patrick McManus <mcmanus@ducksong.com>
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
 v2.6.26-rc3+
In-Reply-To: <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi>
References: <20080529084524.GA24892@elte.hu> <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi>
 <20080529112257.GA18130@elte.hu> <20080530181839.GA31915@elte.hu>
 <20080531060947.GA26441@elte.hu> <Pine.LNX.4.64.0805311431100.2329@wrl-59.cs.helsinki.fi>
 <Pine.LNX.4.64.0805311505410.2329@wrl-59.cs.helsinki.fi> <20080531125428.GA22111@elte.hu>
 <Pine.LNX.4.64.0805311555570.2329@wrl-59.cs.helsinki.fi> <20080531163501.GB22607@elte.hu>
 <20080603094057.GA29480@elte.hu> <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; boundary="-696208474-742855239-1212522473=:3474"
Content-ID: <Pine.LNX.4.64.0806040052271.3474@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-742855239-1212522473=:3474
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0806032248131.3474@wrl-59.cs.helsinki.fi>

On Wed, 4 Jun 2008, Ilpo Järvinen wrote:

> ...I couldn't immediately find anything obviously wrong with those changes 
> but the patch below might be worth of a try (without the revert of 
> course). If it ever spits out that WARN_ON for you, we were playing with 
> fire too much and it's better to return on the safe side there...


> [PATCH] tcp DEFER_ACCEPT: see if header prediction got turned on
> 
> If header prediction is turned on under some circumstances,
> DA can deadlock though I have great trouble in figuring out

...Nah, keepalive timer would then eventually kill it then, so no
deadlock seems possible through that one.

-- 
 i.
---696208474-742855239-1212522473=:3474--
