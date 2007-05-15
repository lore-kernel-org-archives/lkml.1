Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbXEPAUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbXEPAUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbXEPATz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:19:55 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:58828 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbXEPATz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:19:55 -0400
X-Greylist: delayed 1678 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 20:19:55 EDT
Message-ID: <464A4799.10203@vandrovec.name>
Date: Tue, 15 May 2007 16:51:53 -0700
From: Petr Vandrovec <petr@vandrovec.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: dan@dennedy.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
References: <20070507021447.GA22197@vana.vc.cvut.cz> <tkrat.a2f16b56bae46a1e@s5r6.in-berlin.de>
In-Reply-To: <tkrat.a2f16b56bae46a1e@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> On  7 May, Petr Vandrovec wrote:
>> This patch makes raw1394 in current Linux git tree (2.6.21-1570) usable to 32bit
>> applications running on 64bit kernel (tested on i386 app using x86_64 kernel).
> [...]
>> With this in place I was able to run my test app and grab some mpegs, so I believe
>> that I got everything necessary done.  If you believe I have missed some ioctl, yell
>> at me.
> 
> Petr, thanks once again for the fixes.  I took the liberty to split your
> patch into the read(), write(), and ioctl() parts but kept your From:
> and Signed-off-by: and Dan's ACK.  Is this OK with you?  I will reply to
> this message with

Yes, of course.  Thanks a lot.

> [PATCH 1/3] ieee1394: raw1394: Fix read() for 32bit userland on 64bit kernel
> [PATCH 2/3] ieee1394: raw1394: Fix write() for 32bit userland on 64bit kernel
> [PATCH 3/3] ieee1394: raw1394: Add ioctl() for 32bit userland on 64bit kernel
> 
> I plan to do some own testing on a x86-64 box on Thursday and will then
> pass it upstream ASAP.

Thanks.
								Petr

