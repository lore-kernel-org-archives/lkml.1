Return-Path: <linux-kernel-owner+w=401wt.eu-S1763650AbXJNUvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650AbXJNUvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbXJNUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:51:40 -0400
Received: from sd-green-bigip-81.dreamhost.com ([208.97.132.81]:57553 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753531AbXJNUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:51:40 -0400
X-Greylist: delayed 5092 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 16:51:40 EDT
In-Reply-To: <47127FA8.6040506@sonic.net>
References: <47114B46.10403@sonic.net> <1192393469.7573.8.camel@heimdal.trondhjem.org> <47127FA8.6040506@sonic.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1B7E8ED9-7DA9-41CA-BDF9-219E71AAA905@screamingdolphin.net>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Doug Whitesell (LKML)" <dcw-kernel@screamingdolphin.net>
Subject: Re: PROBLEM: kernel panic
Date: Sun, 14 Oct 2007 13:51:38 -0700
To: Scott Petler <scottp@sonic.net>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 14, 2007, at 1:44 PM, Scott Petler wrote:

> Trond,
>
> I'm not exactly sure how to go back to not using the nvidia driver  
> and select the xorg one.  I do know that I wasn't able to use both  
> monitors with the xorg driver, but I'm willing to try that to  
> isolate the problem.

If memory serves, you change your xorg.conf's "Device" section's  
"Driver" entry to read:
"nv"
instead of
"nvidia",

although I would consult the xorg documentation/your distribution's  
documentation (and back up your working xorg.conf) for specific  
details. (Your boot sequence may also automatically load the nvidia  
module, again, consult your distribution's documentation for details.)

Cheers/hope this helps,
dcw
