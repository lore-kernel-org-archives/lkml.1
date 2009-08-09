Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbZHIKk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbZHIKk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 06:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZHIKkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 06:40:25 -0400
Received: from ns.penguin.cz ([84.21.108.25]:49326 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZHIKkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 06:40:24 -0400
X-Greylist: delayed 1114 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Aug 2009 06:40:24 EDT
Subject: Re: ads7846: clean up, fix pressure reporting
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: dtor@mail.ru, linux-input@vger.kernel.org, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Cyril Hrubis <metan@ucw.cz>
In-Reply-To: <20090807180941.GF1728@ucw.cz>
References: <20090807180941.GF1728@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 09 Aug 2009 12:21:33 +0200
Message-Id: <1249813293.4334.24.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Fix pressure reporting, and clean up debug prints.

Thanks.

I see much bigger problem with both the old driver and the new ads7846
driver (2.6.30): They are very noisy on my spitz. When you tap to one
place, keep stylus pressed and just read values, you get 20-200 pixels
long pointer motion trip each second.

According to Cyril Hrubiš, it is caused by the electrical noise that
originates in the LCD display. The driver needs to read data
synchronously with the LCD refresh. He already made the fix for collie
several years ago.
﻿
The pointer test application in the PROM diagnostic utility does not
seem to exhibit any noise.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

