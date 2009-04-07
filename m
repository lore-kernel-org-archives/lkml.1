Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZDTLpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZDTLpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZDTLpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:45:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43007 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbZDTLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:45:16 -0400
Date: Tue, 7 Apr 2009 09:26:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [BISECTED] [REGRESSION] can't anymore even do a
	s2ram-s2disk-s2ram cycle on acer aspire 5720G
Message-ID: <20090407072651.GC1408@ucw.cz>
References: <1239061976.4705.16.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239061976.4705.16.camel@maxim-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Also this commits narrows down the search, now it is clear that this is
> usb related. No wonder bios pokes at usb on resume and stalls.....

So obvious next step is to compile-out usb support and see what
happens?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
