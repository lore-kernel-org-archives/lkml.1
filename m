Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYHLUT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYHLUT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYHLUTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:19:51 -0400
Received: from xes-mad.com ([216.165.139.214]:37632 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYHLUTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:19:51 -0400
Subject: Re: [PATCHv3] leds-pca955x: Add proper error handling and fix
	bogus memory handling
From: Nate Case <ncase@xes-inc.com>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: rpurdie@rpsys.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0808080924560.16201@titan.stealer.net>
References: <1210972198.13845.540.camel@localhost.localdomain>
	 <alpine.LNX.1.10.0808080041460.16201@titan.stealer.net>
	 <alpine.LNX.1.10.0808080852000.16201@titan.stealer.net>
	 <alpine.LNX.1.10.0808080924560.16201@titan.stealer.net>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 15:18:18 -0500
Message-Id: <1218572298.20206.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 09:27 +0200, Sven Wegener wrote:
> Check the return value of led_classdev_register and unregister all
> registered
> devices, if registering one device fails. Also the dynamic memory
> handling is
> totally bogus. You can't allocate multiple chunks via kzalloc() and
> expect them
> to be in order later.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>

Acked-by: Nate Case <ncase@xes-inc.com>

Thanks for the fix.  It looks correct and I tested it on my board with a
pca9553.  I also confirmed that the original driver would in fact kernel
Oops if compiled as a module and you rmmod it.  With this fix, I can
repeatedly insmod/rmmod successfully.

-- 
Nate Case <ncase@xes-inc.com>

