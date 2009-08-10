Return-Path: <linux-kernel-owner+w=401wt.eu-S1751026AbZHJXaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbZHJXaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbZHJXaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:30:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62804 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZHJXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=NYT+6mek/+RaMUxdFqtExlcnqJ2XiHTZcLkl0cvNR601nVMiS5wadwlKGhr1HMqj9p
         vQWpTQhaZBMMKzvJccigltKAHBA0weiyyhMO3TGX6IvaALgHSld+cPMg0pqk9rsCmoKC
         1tcDSnY+oIV2DuNwFfE8Zvw9qyMjhWYDHbFYk=
MIME-Version: 1.0
Date: Mon, 10 Aug 2009 20:30:08 -0300
Message-ID: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
Subject: Flooded by do_IRQ: 0.91 No irq handler for vector
From: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I can't remember since when I've started seeing this, but since 2.6.23
or 2.6.24, I think.
Nowadays, I'm on Ubuntu 9.04, which is kernel 2.6.28.
I'm flooded by the message: "do_IRQ: 0.91 No irq handler for vector"
when in TTY.
This is really annoying for text-base operation or in distros like
sidux, where KDE watches syslog and shows a notification for every new
line.
Believe me, there are thousands of such notifications...
Here is the dmesg results just after logging in:
http://ubuntuforums.org/showpost.php?p=7759222&postcount=2 (yes, I've
posted it in ubuntu forums with no succes ;)
In this log, it's possible to see that the first time do_IRQ
complains, it says: "do_IRQ: 0.99 No irq handler for vector". All
others are for 0.91.
I've tried adding the noirqbalance argument to kernel, and messed with
everything related to IRQ in the BIOS with no success...
Anybody, please help!!!
--
Luis Fernando Planella Gonzalez
