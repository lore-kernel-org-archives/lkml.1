Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbXFUNva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbXFUNva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXFUNvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:51:06 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3498 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXFUNvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:51:05 -0400
Message-ID: <467A825E.9000708@shadowen.org>
Date: Thu, 21 Jun 2007 14:51:26 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: 2.6.22-rc4-mm2: serial-convert-early_uart-to-earlycon-for-8250
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch to 2.6.22-rc4-mm2 seems to update the early console
support for the 8250 uarts:

    serial-convert-early_uart-to-earlycon-for-8250

This moved from naming the 8250 uart 'uart' to 'uart8250' in the
console= kernel parameter.  While this is sensible long term to allow
other uarts to be supported sanely this puts existing users with
existing console configurations in a difficult position as their console
output just stops appearing.  It makes life almost impossible for any
automatic testers as they now need to have different command lines for
different versions of the kernel.

I think we need to maintain 'uart' as an alias here.

-apw
