Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbXH3W3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbXH3W3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762584AbXH3W3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:29:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:42683 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762463AbXH3W3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:29:23 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX19wHnEKCT1wZoJRguDB0IlTFXHMSpQByR9sM0aikA
	ilpLL58ov1pY6J
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: linux-kernel@vger.kernel.org
Subject: Copy large memory regions from & to userspace
Date: Fri, 31 Aug 2007 00:29:20 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708310029.20734.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
Just a short question: What is the correct method of copying large areas of 
memory from userspace into userspace when running in kernel-mode?

According to just about any type of documentation out there something like

unsigned long *from = 0x08000000;
unsigned long *to = 0x09000000;
memcpy(to, from, 0x1000);

should be avoided as copy_from_user, put_user, etc. should be used instead...

Is there a third set of functions for direct from-userspace-to-userspace 
copying or is it legitimate to assure that the first bytes in the from & to 
memory areas are available and then just do the plain memcpy?

Maybe there is a simple "just use the xxx function-set" answer to that, that i 
just have not ran into yet :-)

Thanks!
