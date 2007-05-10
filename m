Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbXEJVDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbXEJVDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760480AbXEJVDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:03:38 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22372 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760945AbXEJVDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:03:37 -0400
Message-ID: <464388A3.5050904@msgid.tls.msk.ru>
Date: Fri, 11 May 2007 01:03:31 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Martin Knoblauch <spamtrap@knobisoft.de>, linux-kernel@vger.kernel.org
Subject: Re: ssh no longer working after upgrading from 2.6.19.2 -> 2.6.21.1
References: <962825.15262.qm@web32608.mail.mud.yahoo.com> <20070510191144.GB5709@martell.zuzino.mipt.ru>
In-Reply-To: <20070510191144.GB5709@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Thu, May 10, 2007 at 11:02:39AM -0700, Martin Knoblauch wrote:
>>> after upgrading a system from 2.6.19.2 to 2.6.21.1 access to that
>>> system via "ssh" has stopped. The ssh-clients accessing the 2.6.21.1
>>> box just hang and cannot even be killed.
[]
> CONFIG_SYSFS_DEPRECATED=y
> 
> 	Alexey, who lost half of today fighting exactly same symptoms

Hmm.  I wonder where the problem is.  What does sshd do with sysfs?
Here, the kernel has CONFIG_SYSFS_DEPRECATED=n, and I haven't noticied
any problems.

Thanks.

/mjt
