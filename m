Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbXENTET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbXENTET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXENTEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:04:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:33746 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXENTEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:04:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=L1xwUEgs3ikaC9FGRX0I0w2wXolbDu49eme6+2Ux69IDZT7xQ+vWmPlbnq8xC0N1uENaOFR8hLcC6hO2l70v8A/oHV92HJKgmPA9F0c9W7kaLRN7sp/kXG3KJcA8hUVlYCzj9GwNGgog/pG7eoljIiPVNUkXW/OVD2DEzZhl26U=
Message-ID: <4648B29A.6080406@gmail.com>
Date: Mon, 14 May 2007 23:03:54 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: pci probe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I do have a device that's a multifunction device. Eventhough a MFD, it
just has one Interrupt which is shared by by a Configuration space for
each function. ie, INTA is shared between them functions.

In such a case, i am wondering, (since pci_probe returns a pointer to
one PCI function alone and i need to use both the functions in one
module alone rather than using a module for each function and that the
functions are quite similar for them to be used in different modules,
such that a separate probe/ISR etc is used) whether using pci_get_device
would be a better alternative to do manual searching for the functions
in such a case.


Thanks,
Manu
