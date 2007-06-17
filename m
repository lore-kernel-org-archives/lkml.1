Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbXFQHIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbXFQHIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 03:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXFQHIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 03:08:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:56851 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbXFQHI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 03:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ErFIUt7MDGaooMdHgv4fW5FpMCweJT1xcsP+G8fIE/hsqk9CbLPhk6MGkkP3nrvLfJzUR5BtOhYDyXgi0ETdu6vBMlMIfGoyLg00beQQHinsCYFqtLRiLm12wAbUC3+busDSKS5L1dcAaAoqqRFNhMOMdLwmS37a5AiHoF0KAt4=
Message-ID: <4674DDEF.8090600@gmail.com>
Date: Sun, 17 Jun 2007 09:08:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] make pci_ids lowercase hexa
References: <116342983010020429@wsc.cz> <20070616195738.GB23443@kroah.com>
In-Reply-To: <20070616195738.GB23443@kroah.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH napsal(a):
> On Sat, Jun 16, 2007 at 05:44:52PM +0200, Jiri Slaby wrote:
>> make pci_ids lowercase hexa
> 
> Why?  What good is this going to do in the long run?

It's just cleanup to get rid of things like this:
 #define PCI_DEVICE_ID_PROMISE_20246	0x4d33
 #define PCI_DEVICE_ID_PROMISE_20262	0x4d38
-#define PCI_DEVICE_ID_PROMISE_20263	0x0D38
+#define PCI_DEVICE_ID_PROMISE_20263	0x0d38
 #define PCI_DEVICE_ID_PROMISE_20268	0x4d68

But still not necessary, if you think, it's useless -- but why don't have whole
document formatted in one way. However this patch needs a -fix if ACKed due to
bad regexp used (omitted '*' changes only the first uppercase letter found). If
NACKed, this doesn't matter.

> Also, shouldn't you send pci specific patches like this to the pci
> maintainer?  :)

Hell yes :/, every second time I post something, somebody is missing in the CC
list, grr.

thanks,
--js
