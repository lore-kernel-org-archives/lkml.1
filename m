Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbZLHPzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbZLHPzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162AbZLHPzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:55:55 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:43775 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbZLHPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=QRdocVYqxzXUE5lv3jj7HA2ccoRBYZK6AmKOG0kLhrHKQ2K5zAffYIn39h7aCHrvP2
         wPF2ykdg3L6vaKOajDzITKNmfxaV5Z80FRUmt+vopQUwle3dQqp3xXRHp9T/OmHocePe
         tMqcF4AxrdaRJxtdyTr9f1DnJ5jRGJZIu79gI=
Message-Id: <20091208155316.561853924@openvz.org>
User-Agent: quilt/0.47-1
Date: Tue, 08 Dec 2009 18:53:16 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com
Cc: macro@linux-mips.org, yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] apic snipptes on latest -tip/master
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review, comments/complains are quite welcome.
First patch -- to add checking if we have apic being active
why trying to setup thermal monitor interrupt, and the second
one -- my attempt to explain why noop'ified apic read/write
do check for apic being active/allowed to operate in a different manner.

Cyrill
