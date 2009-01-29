Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbZA2Adr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbZA2Adr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761173AbZA2AOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:14:25 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:33471 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760334AbZA2AOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=CLxK2OiPilgGdN6oks/9erLvDZrxvzEhhcttQF48gfcyFUO4oXEy2Y+PvN8h7fZRKH
         ImmByLoJJODNWVUZ9A+euQR+WKnStHdrhafdy+a0pGTSrSgJC3y5bbUosDCTmz4A2UXW
         LphXQltFOKobhzScpd3tyvqpkwAD/V99HuVi8=
Date: Wed, 28 Jan 2009 19:14:11 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
       torvalds@linuxfoundation.org, akpm@linuxfoundation.org
Subject: 2.6.29-rc3: tg3 dead after resume
Message-ID: <alpine.DEB.2.00.0901281858380.5048@parag-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With 2.6.29-rc3 suspend/resume has started working on my workstation again 
(did not resume with rc2 - not sure when it broke) but tg3 is dead 
after resume.

This is similar to the issue reported back in Jul 2007 - 
http://kerneltrap.org/mailarchive/linux-kernel/2007/8/1/154073/thread 
which was fixed with a patch to unconditionally save/restore pci config 
space - that one is still in tg3.c.

After resume tg3 complains that no firmware is running and eth0 is 
non-existent. Rmmoding and modprobing tg3 again causes some timeouts and 
errors from tg3 and the link still doesn't work.

Reboot fixes it.


Parag
