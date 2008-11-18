Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbYKRL7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbYKRL7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYKRL7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:59:46 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:16126 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYKRL7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:59:45 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62702338"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [alsa-devel] [PATCH 5/8] ASoC: Fix BUGS in Blackfin AC97 DAI
Date: Tue, 18 Nov 2008 11:58:55 -0000
Message-ID: <8A42379416420646B9BFAC9682273B6D0693623D@limkexm3.ad.analog.com>
In-Reply-To: <20081118115426.GG23217@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel] [PATCH 5/8] ASoC: Fix BUGS in Blackfin AC97 DAI
Thread-Index: AclJdJzb5BIcf5JKROGy2hZ/XuVbKgAAA99w
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org> <1226996302-10234-6-git-send-email-cooloney@kernel.org> <20081118115426.GG23217@sirena.org.uk>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@sirena.org.uk>, "Bryan Wu" <cooloney@kernel.org>
Cc: <tiwai@suse.de>, "Cliff Cai" <cliff.cai@analog.com>,
       <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 18 Nov 2008 11:59:43.0050 (UTC) FILETIME=[2494C2A0:01C94975]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> sport_handle is a global and not allocated my kmalloc.
>
>There's no reference to sport_handle in the patch...

Sorry - spurious comment please ignore.

-Michael

>-----Original Message-----
>From: Mark Brown [mailto:broonie@sirena.org.uk]
>Sent: Tuesday, November 18, 2008 12:54 PM
>To: Bryan Wu
>Cc: tiwai@suse.de; Cliff Cai; alsa-devel@alsa-project.org; linux-
>kernel@vger.kernel.org; Michael Hennerich
>Subject: Re: [alsa-devel] [PATCH 5/8] ASoC: Fix BUGS in Blackfin AC97
DAI
>
>On Tue, Nov 18, 2008 at 04:18:19PM +0800, Bryan Wu wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>
>> sport_handle is a global and not allocated my kmalloc.
>
>There's no reference to sport_handle in the patch...
>
>> A probe function should have a clean return 0 path.
>
>...only this.
