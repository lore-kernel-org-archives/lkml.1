Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbZELKHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbZELKHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZELKHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:07:01 -0400
Received: from rankki.sonarnerd.net ([83.145.240.118]:46496 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbZELKHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:07:00 -0400
Message-ID: <4A094A44.30905@sonarnerd.net>
Date: Tue, 12 May 2009 13:07:00 +0300
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
> I certainly don't think the current situation is bad enough to warrant
> things like that, media on my machines works peachy (*cheer* for XV on
> R600).

By the way, here's a good test case for a desktop, preferably UP:
 - run something like this in a loop:
	find / -type f -exec grep asd "{}" ";"
 - run x11perf * numcpus in a loop
 - run glxgears * numcpus
 - go to youtube frontpage with a web browser
 - start for example "totem" mediaplayer and play full-HD H.264 movie

Does the movie playback and audio go smoothly? Can you play youtube HD
videos smoothly?


	- Jussi
