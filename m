Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbXDIREI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbXDIREI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXDIREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:04:08 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXDIREH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:04:07 -0400
Message-ID: <461A71FA.40900@zytor.com>
Date: Mon, 09 Apr 2007 10:03:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
References: <200704091007.58535.gene.heskett@gmail.com> <461A5204.1050206@garzik.org> <200704091137.01336.gene.heskett@gmail.com> <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> dm is on 254 for me.. in opensuse with a 2.6.20 that is. I wonder why it
> even moves around. However, even then, those who use udev and device names
> rather than (major,minor) tuples should not have any problem.
> 

It moves around because someone at some point thought it was a great 
idea to assign dynamic majors to core functionality.

It stays put at 254 for you since that's the highest (and thus 
first-used) dynamic major.

	-hpa
