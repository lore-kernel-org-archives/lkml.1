Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbXLRRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbXLRRlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXLRRlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:41:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:34013 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbXLRRlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:41:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LBnNY4Pxl+VGbAZRwKC33AlPI2Ee6RcPrBHMePem4zYbnFkrQOnjODtlXnbT9xjanWjvUnHtlCx1AR9OuDvHLMK+kUcrLKdWHp0jvKolc/gV3zpFdA9jnnG8jNhW8t/v+zUEYba4z3bV6sYlFADmorecFHFakPxbj6a4ohSdgiA=
Message-ID: <c166aa9f0712180941o765cba7fxf31705560a51a06c@mail.gmail.com>
Date: Tue, 18 Dec 2007 11:41:05 -0600
From: "Andrew Dyer" <amdyer@gmail.com>
To: wim@iguana.be
Subject: watchdog behaviour on close? (watchdog-api.txt)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I am trying to implement a watchdog driver in 2.6.23 for the i.MXL
cpu (based off of drivers/char/watchdog/s3c2410_wdt.c).

I had a question about the api doc for the watchdog
(Documentation/watchdog-api.txt).  Line 37 says "When the device is
closed, the watchdog is disabled."  Later on (Line 56) it says
"Drivers will not disable the watchdog, unless a specific magic
character 'V' has been sent /dev/watchdog just before closing the
file."

I would assume that from reading L37 that the driver would
unconditionally shut down the watchdog when closing (unless
CONFIG_WATCHDOG_NOWAYOUT or the nowayout module param is specified),
but line 56 seems to contradict that.

Can you clarify the intended behaviour?

I am not subscribed to the mailing list, so please cc: replies to me.
-- 
Hardware, n.:
        The parts of a computer system that can be kicked.
