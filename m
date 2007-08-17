Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbXHQUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbXHQUtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXHQUtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:49:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:21779 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbXHQUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=B2z58yXGkq0yLM3zRTHc752SlotcL2H5zijONc5pqFMSiblt43Y3Gs0epjZ48qZvrYjacSqEytztvFQzOnYOCKq2uRsnfFFsQyygWOf9WXKu0Lf1793g/g777hymDnHH9l3PmC17xh0wlwJDLmjNdbavsT9Gu3CmljeNXMHv6dg=
Message-ID: <ab40e9c0708171349n73e35f58p5f5c092b54ddeb45@mail.gmail.com>
Date: Fri, 17 Aug 2007 22:49:21 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: how to add debug information into the vmlinux
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I am trying to port kernel 2.6.19 onto my system.so I need the c code
, which can show me where the program is running. I add -g when I
compile it.

after I got the vmlinux( uncompressed) I used arm-none-eabi-objcopy
--change-addresses 0x40000000 to change the start address.

it seems that the debug information is strange. expecially after the
mmu is turned on , it totally disappreared.

anyone knows how to handle this?

thanks in advance.

regards,

yang
