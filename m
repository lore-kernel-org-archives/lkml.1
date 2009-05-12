Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbZELJxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbZELJxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbZELJxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:53:14 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:41051 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZELJxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:53:13 -0400
Message-ID: <4A094707.5040307@sonarnerd.net>
Date: Tue, 12 May 2009 12:53:11 +0300
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: James Courtier-Dutton <James@superbug.co.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, d.faggioli@sssup.it
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net> <1242107859.11251.301.camel@twins>
In-Reply-To: <1242107859.11251.301.camel@twins>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> As to the patch, I still think its an exceedingly bad idea to create
> such a horridly ill defined scheduler class. There's nothing that keeps
> people from stuffing everything in there and either generating DoS
> issues or still generating bad interactivity.

Lite patch practically exports nice levels as scheduling priorities in
order to make it possible to assign different levels to different
threads of the same process.

> I certainly don't think the current situation is bad enough to warrant
> things like that, media on my machines works peachy (*cheer* for XV on
> R600).

Naturally pretty much anything works when CPU load is under 25%. When
the load on low power embedded system is around 95-100% things get
hairier...

"Buy faster CPU" is not always an option...


	- Jussi
