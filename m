Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbZJPTxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbZJPTxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZJPTxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:53:18 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39389 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZJPTxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=PY63x06/qIQgDByZdxW0zuWpCpWklOmWW7/uTc8RYUrMrWOPisuM4/GbTZbOVkEh9p
         qnirpz3UDCagd4VufAkuQTQ7V9RWuAZdEHj95WkJtTy+45T/nqVfqWnHbgxD8qEP3cAu
         zQGzRldOX2pizJSRPezXfOvQ/9RpUFSp9itfI=
MIME-Version: 1.0
Date: Fri, 16 Oct 2009 21:53:22 +0200
Message-ID: <b637ec0b0910161253y60eb6b4fl3e49e5b9129d81ac@mail.gmail.com>
Subject: [Regression] - 2.6.32-rc5 hangs using rfkill on an eeePC
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.
Pressing rfkill button on my eeePC 900 to disable wireless hangs the system.

In console I can see (warning: what follows is copied by hand):

acpid: client 148[6:100] has disconnected
ACPI group/action not found: hotkey / ATKD
unregister netdevice: waiting for wlan0 to become free; usage count=1

(last line repeats forever). Hard reset is needed.

With any previous kernel version (I'm running -rc4 right now) everything works:

ACPI group/action undefined: hotkey / ATKD
ath5k 0000:01:00.0: PCI INT A disabled

(there's no acpid line)


Regards,
Fabio
