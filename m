Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYEMKgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYEMKgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYEMKg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:36:28 -0400
Received: from mx03.syneticon.net ([87.79.32.166]:3437 "EHLO
	postfix1.syneticon.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752834AbYEMKg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:36:27 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 06:36:27 EDT
Message-ID: <48296CBD.9030904@wpkg.org>
Date: Tue, 13 May 2008 12:26:05 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, sancelot@free.fr
Subject: Re: detecting kernel mem leak
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I kept my kernel running with few applications for 5 days , doing
> nothing more than backing up few kb of data on disk and refresh few X apps.
> 
> Ater five days the global memory available go down from 24Mb to 8Mb ...
> 
> The are some signifiant changes in slabinfo but now, I do not know where
> to search ?

Look at these values more closely - this is where your memory is "gone":


> MemFree:          24324 kB.................8692Kb
> Buffers:              3956   kB...............18740Kb


-- 
Tomasz Chmielewski
http://wpkg.org

