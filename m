Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbZLEOkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbZLEOkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZLEOki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:40:38 -0500
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:45510
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZLEOki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:40:38 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Dec 2009 09:40:38 EST
Message-ID: <4B1A6F78.8010408@myrealbox.com>
Date: Sat, 05 Dec 2009 09:34:32 -0500
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Emmanuel Benisty <benisty.e@gmail.com>
CC: linux-kernel@vger.kernel.org, tiwai@suse.de, jbarnes@virtuousgeek.org,
       intel-gfx@lists.freedesktop.org
Subject: Re: 2.6.31 -> 2.6.32 Sound and video regressions
References: <c1f41c620912042148n7d3f6f29h713a2d44369a5810@mail.gmail.com>
In-Reply-To: <c1f41c620912042148n7d3f6f29h713a2d44369a5810@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emmanuel Benisty wrote:
> Hi,
> 
> I hope I didn't miss something but given the traffic of LKML, that
> could have happened.
> 
> I just wanted to report 2 regressions I am having now with 2.6.32.
> 
> Video
> Screen is flickering/glitching like crazy in X. It happens whether
> randomly or when conky is refreshed, when the mouse cursor moves and
> like hell when a page is loading in the browser. Not so easy to
> describe this issue.
> Xorg.0.log is attached.
> (I've uploaded an utterly crappy mobile phone video if needed but I
> doubt this could be of any help, anyway, it's here
> http://omploader.org/vMngzcA/Xorg.tar.bz2 )

That sounds like FIFO underruns, which (I think) were introduced when 
self-refresh was enabled but should have been fixed.  I personally have 
no clue how to fix them, but if you told the Intel people what kind of 
chip you have (lspci output), they can probably fix it.  (cc added)

--Andy
