Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYFZBBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYFZBBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYFZBBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:35 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:20470 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbYFZBBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=YgINhSv+ny+F3NY3wbpNSMSHNfINodMFkqQ536EL8gTOQbX7MK20sTpDROTtQyVKDK
         eLZnNXFEIR28elljUlNPl2PBAs+xxP5lbaWEMLX/aAGhTb1zJ/SXFr6drGojXJESSvil
         PYTSzX4toHNXzs1ywCcsuo/3CasuylMQgfD4k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 00/16] x86: merge setup_32/64.c
Date: Wed, 25 Jun 2008 17:48:06 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806251748.06743.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the patches

it will rename setup.c to setup_percpu.c and make setup_32.c to support 64bit, and then change setup_32.c to setup.c 
and delete setup_64.c.

Thanks

Yinghai Lu
