Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbZCKN3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbZCKN3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZCKN3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:29:05 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:63957 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbZCKN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=NQN7hhJcj/XqHA3AcZGoAKvR+rvk2FPTaauFWRfh2Rx1PcC09lRbsegJ8jdNel6U+m
         YfU6+axc19u6ZWHh0pyasbvZglroFB3Zu0tSxsEY2wGuoDDYQbOjH00Hh8IubN/NIcEv
         77PRBdPI5GXtBBVnCnevooHwQVL0Yb991IZcU=
MIME-Version: 1.0
Date: Wed, 11 Mar 2009 14:28:59 +0100
Message-ID: <5b9cce670903110628p45248032u50dc253ed18b6e46@mail.gmail.com>
Subject: pci express bar over 4gb
From: protagora27 protagora27 <protagora27@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Folks,

I have intel desktop board dx48bt2. I'm developing sw under linux
2.6.24  x86_64  for a pci express card ( pci express 2.0 compliant).
I have to setup pci bar over 4 gb but bios uses value e0000000 as base
address for pcie boards.
I have seen that pciexbar is a register ( x48 chipset)  that decides
where pcie boards are mapped inside memory map.
My goal is rewriting pcibar 0 e pcibar 1 with a value above 4gb. Maybe
 I have  to rewrite pciexbar and then rewrite pci bar in my board.
Questions:
1) can I rewrite  pciexbar  and where ?
2) can i rewrite pcibar 0 and 1 with a value over 4 gb
3) If i change bar 0 and bar 1 after linux startup have i to use hotplugging ?

Thanks

Luca
