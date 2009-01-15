Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbZAOXCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbZAOXCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936628AbZAOWyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:54:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936629AbZAOWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:54:05 -0500
X-Greylist: delayed 18002 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 17:54:04 EST
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Date: Thu, 15 Jan 2009 23:53:24 +0100
User-Agent: KMail/1.9.9
Cc: Ira Snyder <iws@ovro.caltech.edu>, Jan-Bernd Themann <themann@de.ibm.com>,
       netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>
References: <20090107195052.GA24981@ovro.caltech.edu> <200901152222.55006.arnd@arndb.de> <20090115214056.GC9091@ovro.caltech.edu>
In-Reply-To: <20090115214056.GC9091@ovro.caltech.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901152353.25052.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+FJLreOtGGi508kX6XNUVH6y7Nun70GXx2wI4
 eZMueTVp6ju4w/DBt2ESQ+X0SDeZNJJBxJ9gms1iXUQ+mj4IW5
 yqn7IzYjdkQu/XOA4eHTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Ira Snyder wrote:
> I do have mailboxes (two inbound, two outbound) which can generate
> interrupts, as well as doorbell registers (one inbound, one outbound).
> The doorbell register's bits are "write 1 to clear", and can only be
> cleared by the opposite side.
> 

Ok, in this case, you should be able to use one of these to implement
the DMA complete interrupt, but adding an extra DMA transfer to the
mailbox after each transfer that you want to get notified for.

	Arnd <><
