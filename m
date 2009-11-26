Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbZKZNZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbZKZNZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZKZNZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:25:03 -0500
Received: from smtp.nokia.com ([192.100.105.134]:19662 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZKZNZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:25:01 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Andy Walls <awalls@radix.net>
Subject: Re: linux-next: workqueues tree build failure
Date: Thu, 26 Nov 2009 15:23:40 +0200
User-Agent: KMail/1.12.3 (Linux/2.6.31-gentoo-r4; KDE/4.3.3; i686; ; )
Cc: ext Mark Brown <broonie@opensource.wolfsonmicro.com>,
       ext Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au> <200911261344.32051.peter.ujfalusi@nokia.com> <1259239796.3062.20.camel@palomino.walls.org>
In-Reply-To: <1259239796.3062.20.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911261523.40952.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 26 Nov 2009 13:23:45.0386 (UTC) FILETIME=[AE20ECA0:01CA6E9B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 14:49:56 ext Andy Walls wrote:
> 
> Peter,
> 
> I would suspect using a single-threaded workqueue is better than a
> wake_up() of another thread.  IIRC, after queuing work, the workqueue's
> single thread may run almost immediately on the same processor.  With
> waking up sleeping threads, I've run into scheduler delays around 10 ms
> on a dual core x86_64 desktop system.

Hello Andy,

I have sent the patch which changes from rt to singlethread, I hope it fixes the 
breakage in linux-next.
In short testing, when there is virtually no load on the system I can not see 
any difference, which might change later.
But I'll keep in mind that probably I'm not going to better off with the waking 
up of a sleeping thread.

> 
> Regards,
> Andy

Thanks,
Péter
