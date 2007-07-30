Return-Path: <linux-kernel-owner+w=401wt.eu-S966890AbXG3RDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966890AbXG3RDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXG3RDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:03:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:26756 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789AbXG3RDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=d2SBcXJ3sv80LVz2hRbI+Ezx8cqJzM4s1H0H8MC/LNyy27qZRO09w7OpihXQ9k3ZQhH9VWUCFKdqgXwovwOR50tol560Tps67CNVivE1mK+CnkHz6wUr1DMPlgZB0uC0vUzZCTQ0kTSNaTDkl3sW+VGSiJ5l/6HwuzKQ0iye27U=
Message-ID: <46AE18DE.5010704@googlemail.com>
Date: Mon, 30 Jul 2007 18:59:10 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: dbrownell@users.sourceforge.net, linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>
Subject: drivers/usb/gadget/dummy_hcd.c - DEBUG redefined warnings 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed the following warnings with a randconfig ( http://194.231.229.228/git-current/randconfig-auto-34 ):

...

 CC [M]  drivers/usb/gadget/dummy_hcd.o
drivers/usb/gadget/dummy_hcd.c:37:1: warning: "DEBUG" redefined
<command-line>: warning: this is the location of the previous definition
  CC      drivers/scsi/scsi_transport_sas.o
  CC      drivers/usb/core/notify.o
  CC      drivers/usb/core/generic.o
drivers/usb/gadget/dummy_hcd.c:37:1: warning: "DEBUG" redefined
<command-line>: warning: this is the location of the previous definition

...


Line 37 is #define DEBUG , is that really needed ?



Regards,

Gabriel C
