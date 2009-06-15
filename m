Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZFOHW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZFOHW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZFOHWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:22:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:29547 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZFOHWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:22:15 -0400
X-IronPort-AV: E=Sophos;i="4.42,220,1243828800"; 
   d="scan'208";a="4634210"
Subject: Re: [OOPS] [XEN] OOPS early after boot on master
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bryan Donlan <bdonlan@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       <xen-devel@lists.xensource.com>
In-Reply-To: <3e8340490906111555r313ff6e9nce956fc76eff7382@mail.gmail.com>
References: <3e8340490906071010l33ceaf5eh304e163178384592@mail.gmail.com>
	 <3e8340490906081305u1ad00ba7s78b367e4fa8973c4@mail.gmail.com>
	 <4A317433.5000700@goop.org>
	 <3e8340490906111555r313ff6e9nce956fc76eff7382@mail.gmail.com>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Mon, 15 Jun 2009 08:13:59 +0100
Message-ID: <1245050039.5782.867.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 18:55 -0400, Bryan Donlan wrote:
> On further analysis, it seems that that's a red herring - disabling PV
> spinlocks just makes it occur less often, I think... I'm currently
> still bisecting it; it's complicated by other OOPS-causing bugs having
> existed in the interim, but it definitely existed before the
> introduction of CONFIG_PARAVIRT_SPINLOCKS.

It's worth bearing in mind that prior to CONFIG_PARAVIRT_SPINLOCKS the
pv spinlock functionality was already present but not optional so it's
not unlikely that an issue with pv spinlocks could predate the addition
of the option.

Ian.


