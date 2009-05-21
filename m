Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZEULzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZEULzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZEULzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:55:13 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:6013 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZEULzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:55:12 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4A15411F.3050704@tremplin-utc.net>
Date: Thu, 21 May 2009 13:55:11 +0200
From: =?windows-1252?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] lis3: remove automatic shutdown of the device
References: <4A151E9F.1080405@tremplin-utc.net> <4A151F52.3050908@tremplin-utc.net> <20090521113618.GF2637@elf.ucw.cz>
In-Reply-To: <20090521113618.GF2637@elf.ucw.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 21-05-09 13:36, Pavel Machek schreef:
> Hi!
> 
>> After measurement on my laptop, it seems that turning off the device
>> does not bring any energy saving (within 0.1W precision). So let's keep
>> the device always on. It simplifies the code, and it avoids the problem
>> of reading a wrong value sometimes just after turning the device on.
> 
> Well, 0.1W is still quite much for cellphone etc... but as we do not
> have any such small users in the tree, I guess this can go in...
> 
Yes. BTW, what I meant is that the power consumption on my laptop can be
read with 0.1W precision. Turning on and off the device showed 0.0W
variations. The device should using even much less than 0.1W. According
to the documentation, it's about 2.2mW when on and 3µW when off.

Eric


