Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXIWQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXIWQRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 12:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbXIWQRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 12:17:43 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:45572 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbXIWQRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:17:42 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH 1/2] cxacru: Use appropriate logging for errors
Date: Sun, 23 Sep 2007 18:17:36 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <46F68708.6070409@simon.arlott.org.uk>
In-Reply-To: <46F68708.6070409@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709231817.39076.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon, don't these error messages (except the first) risk spamming
the log if something goes wrong (like the modem being unplugged)?  How
about rate-limiting them, like usbatm does?

Ciao,

Duncan.
