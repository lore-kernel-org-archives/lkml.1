Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYKRBgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYKRBgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYKRBgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:36:07 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:33082 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYKRBgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:36:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=r9qLwPnFQADjjITJFzQ5Bw0xnLgKyN5tQ7S2XnEOBKlgzXTZ7BjwtgGx28majGd4pN
         YnI1PHjgckDDVxGZkJyV1l1irWYkqd5mbZGFalv4KsKOMeJgxYK4NQ/RmdByDNN1pU6e
         pSGYJ92/NvWnMjz2Zu7yCLvfnjM1OFZmwRuKo=
Message-ID: <e38d12ff0811171736h1238ee6at4bafe06dafff6378@mail.gmail.com>
Date: Mon, 17 Nov 2008 20:36:02 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: how to show ACPI key events
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hacked atkbd.c to dump every keycode and enabled CONFIG_EVBUG yet
the Fn+F{1..12} and Fn+{arrow} keys don't register an event. Is there
a way to hack the ACPI drivers to dump keycodes?

>From hacking at the Windows drivers, pressing the hotkeys generates an
acpi event. How do I get the acpi key events dumped?

One-liners if possible, please.

--
Andrey Vul
