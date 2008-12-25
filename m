Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbYLYUSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbYLYUSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYLYUSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:18:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:11252 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYLYUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:18:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Vx1JMzrh1Pub8ONA2WSF/fzvAm3WdEgGCFyIz0hTju2pAO74WznsuU9GJLtfW/8YDE
         d8VJpLZM0bYc8X48omtQgPbr53xhIOWSMLZi/5vyH0pYzaWmes4yeK0APWZBE/XsHOSY
         SWe7Ct0lqMpOujIKjRwfg4WK+U/wQ2CVHmnbU=
Message-ID: <742b1fb30812251218k66a090f6je8c1e0f9d98dffc5@mail.gmail.com>
Date: Thu, 25 Dec 2008 21:18:42 +0100
From: "Patrizio Bassi" <patrizio.bassi@gmail.com>
To: "Kernel," <linux-kernel@vger.kernel.org>
Subject: [BUG] Kernel Panic with ath5k and 2.6.28
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel Panic with ath5k and 2.6.28

Hi all,

Today i migrated to 2.6.28 and ath5k from 2.6.27 and madwifi.
I have a trust speedshare turbo 108mb/s card
Connection is ok, even with WPA.

The problem i met is when i tried to bridge the wifi and the eth interface.

I just rebuild the kernel with the bridge module enabled (builtin) and
i got the panic
in the picture (http://www.patriziobassi.it/downloads/ath5k_panic.jpg)
when i try to put the wifi interface up on startup with old script configuration

The strange thing is that i'm not adding it to the bridge, i just have
it in the kernel and i'm enabling the interface.
Eth interface goes up flawlessy.
Workaround is to boot the laptop without the card plugged it (pcmcia)
or do not compile the bridge into the kernel.

Attaching the working config. the broken just has the bridge module enabled.

I'm ready to test all the patches/suggestions you may provide.

Config is at http://www.patriziobassi.it/downloads/config-2.6.28

I wish u all merry xmas.

CC me i'm not subscribed

---
Patrizio Bassi
www.patriziobassi.it



--
Patrizio Bassi
www.patriziobassi.it
http://piazzadelpopolo.patriziobassi.it
