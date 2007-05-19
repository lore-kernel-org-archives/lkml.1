Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXESNx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXESNx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 09:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbXESNxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 09:53:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:48990 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757754AbXESNxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 09:53:48 -0400
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, kenchen@google.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 19 May 2007 15:53:46 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070519135346.289090@gmx.net>
MIME-Version: 1.0
Subject: bug in 2.6.22-rc2: loop mount limited to one single iso image
To: linux-kernel@vger.kernel.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+rxuhA0f+rEvw+juHmLKrZj9nfgOYCNMjg75VgJs
 UTQLHWzCvGq1JDNQYNesy8ltYrjZA9a3ZyxA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: XjN2fttFYW0tcGD9HmZpu3l8amthc9ug
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running Debian Etch 4.0 stable in connection with udev.

In kernel 2.6.22-rc2 the number of available loop mounts is reduced from 8 (conventional standard of preceding 2.6 kernels) to 1.

Symptom: If you try to mount more than one single iso-image with
the loop parameter you are receiving the following message during system boot:

"mount: could not find any free loop device"

Kernel 2.6.20.11 does not show that problem.

Question: Can someone reading this confirm and reproduce that problem?
If yes: Are there any fixes available?

Thanks and Regards

Uwe

-- 
Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen! 
Ideal für Modem und ISDN: http://www.gmx.net/de/go/smartsurfer
