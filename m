Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYHXJDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYHXJDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYHXJCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:02:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYHXJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BbhrlLHLy9+Y7VjM03m+6ktc7WkSq2eeM/EO6w6d5M3MwvN1/lntKx+EPDVXIrz5cW
         9vQInsmMpfhDugZNPdosmvgo7RFwV/iJge4/JxlT39gsQRXhB3EebW2e46czlnJAOfSY
         v4wbimW2Yyn3uYpdfPmu6To8hX9G+9q4rcfMk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/18] merge apic_32.c and apic_64.c
Date: Sun, 24 Aug 2008 02:01:38 -0700
Message-Id: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	calibrated_APIC_clock still have two copies.
	it seems we should use 32 bit, because some system may not has tsc
	but it is some long than 64 bits...

Thanks

Yinghai Lu

