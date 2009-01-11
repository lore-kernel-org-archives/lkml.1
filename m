Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZAKTxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZAKTxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZAKTw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:52:59 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:46264 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZAKTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iPcvGs8LCni7vmm+3yG0BY0rhsQAcyn4ZPd2cbKaxEoHlMeE6G7ei5Vu2X0kYb0phG
         C2lIsh3aENiJKrTpEG/iVYBDpvFIXnVVqOKVWuDDVzNxdU1GMFlREdK5b7v/iiJtbHBb
         /ROMRv97l+fxeDPpR+hKC8s7iEd7laaCQNtTg=
Message-ID: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
Date: Sun, 11 Jan 2009 20:52:56 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've booted and tested 2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)

I've observed that suspend is unusable - it goes to sleep - the sleep
LED is on. After few secs system turns on back itself - and stays in
some frozen state
and the sleep LED is still on. Usually I get black screen - but once
I've noticed screen with this text:

x86 PAT enabled  cpu0,.....
back to C
Extended CMOS year 2000

but most probably this is not very helpful - however it's kind of hard
to bisect kernel, because patches in the transition from
2.6.28->2.6.29-rc1 usually caused a lot of unstable behavior on my
T61.

So are there any suspected patches I could try to revert directly ?
(I would have assumed some new ACPI controlling for thinkpad - thought
I don't understand why it's get broken over and over again)

Zdenek
