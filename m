Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbZF3DBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbZF3DBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 23:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZF3DBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 23:01:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZF3DBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 23:01:30 -0400
Date: Mon, 29 Jun 2009 20:01:22 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: penberg@cs.helsinki.fi
Subject: WARNING: at mm/bootmem.c:535 alloc_arch_preferred_bootmem
Message-ID: <alpine.DEB.2.01.0906291950280.6439@bogon>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/PNoikODSJe9CPKRQz7PbdUC5VTzQR9k77AEA
 LhYPH+e0Nl3neWk+ud4zziELzemIWdw8rfxyPKdFpN+B69c95P
 N8SRiI9sk8ZsZUJHgVodA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

this topic has been discussed [0] already and a bug for powerpc[1] has 
been opened, I'm still seeing this with the latest -git in a x86_64 Xen 
DomU. The domain continues to boot however, no oopses or crashes so far, 
it's just this warning during bootup. The thread about the "early boot 
SLAB" came to a halt, but the warning is still there - is a fix for this 
still in the works?

Full dmesg/.config: http://nerdbynature.de/bits/2.6.31-rc1/

Thanks,
Christian.

[0] http://bugzilla.kernel.org/show_bug.cgi?id=13650 / Badness on the Warp
[1] http://lkml.org/lkml/2009/6/10/396 / Early boot SLAB for 2.6.31
-- 
BOFH excuse #36:

dynamic software linking table corrupted
