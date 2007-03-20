Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbXCTH3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbXCTH3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbXCTH3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:29:11 -0400
Received: from rnd-off.balt.net ([195.14.167.137]:17020 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753336AbXCTH3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:29:10 -0400
Subject: Re: Kernel Oops in  pl2303_shutdown()
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Adrian Bunk <bunk@stusta.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070319163423.GV752@stusta.de>
References: <1174318078.4601.77.camel@zv.wilibox.com>
	 <20070319163423.GV752@stusta.de>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 09:07:31 +0200
Message-Id: <1174374451.6023.2.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Adrian,

reverting d9a7ecacac5f8274d2afce09aadcf37bdb42b93a does help. 
thanks !


On Mon, 2007-03-19 at 17:34 +0100, Adrian Bunk wrote:
> On Mon, Mar 19, 2007 at 05:27:58PM +0200, Zilvinas Valinskas wrote:
> > Hello, 
> > 
> > Before 2.6.21-rc4 (vanilla) serial was oopsing if I pull usb-serial
> > cable while minicom was running. Now it doesn't matter if minicom is
> > running or minicom closed, pulling serial cable results in such oops.
> >...
> 
> Does the patch from [1] fix it?
> 
> cu
> Adrian
> 
> [1] http://lkml.org/lkml/2007/3/13/217
> 

