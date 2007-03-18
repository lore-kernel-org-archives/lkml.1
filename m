Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXCROgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXCROgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 10:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXCROgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 10:36:10 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:58994 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752784AbXCROgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 10:36:09 -0400
Message-ID: <45FD4E59.3050007@gmail.com>
Date: Sun, 18 Mar 2007 15:36:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <Pine.LNX.4.44L0.0703181012440.18068-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703181012440.18068-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern napsal(a):
> In drivers/usb/host/uhci-q.c, near the start is a function named
> uhci_fsbr_on().  Put a "return" statement right at its beginning so that
> the function doesn't do anything.  Does that make any difference?

Yes, it works.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
