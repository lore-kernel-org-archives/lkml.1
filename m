Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZGLTuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZGLTuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 15:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZGLTuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 15:50:08 -0400
Received: from smtp.nokia.com ([192.100.122.230]:28117 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZGLTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 15:50:07 -0400
Date: Sun, 12 Jul 2009 22:49:33 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Felipe Balbi <me@felipebalbi.com>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ben-linux@fluff.org
Subject: Re: [rfc/patch 02/15] power: bq27200: this is an i2c device
Message-ID: <20090712194933.GC11692@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <63386a3d0907121147x5065be43tf9d19e9e33f0ffbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0907121147x5065be43tf9d19e9e33f0ffbd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Jul 2009 19:49:39.0327 (UTC) FILETIME=[E45C30F0:01CA0329]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 08:47:53PM +0200, ext Linus Walleij wrote:
> 2009/7/12 Felipe Balbi <me@felipebalbi.com>:
> 
> > ... with hardcoded device address so i2c subsystem won't
> > talk to more than one of those.
> 
> So you remove support for multiple instances of this driver, OK.
> 
> But theoretically, what happens if you have two different I2C busses
> on your system with a battery driver on each?
> 
> Can you confirm that that will never happen?

If they are on different buses, there shouldn't be any problems.
Unfortunately I don't have a hw suitable for this kind of test.

Let's hear from Ben Dooks on this.

-- 
balbi
