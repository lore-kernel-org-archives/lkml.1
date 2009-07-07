Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZGGPZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZGGPZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZGGPZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:25:22 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:39120 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZGGPZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=T0nhASdFD2i142KVVH2WQpwFKufV3b0uY/Ior1rTmbvliigEqsYWBp8eeF5faomnUc
         GFM5uzKZKQDXSTTOvZCgvgwdAc19rIO9JbZkWEI/OJweJb7dDvjNAm+kDbz9q7/L91zr
         GPdtufHv+VrTwIZM8Z6NlFVfzyAus2jI0KNYY=
MIME-Version: 1.0
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 16:24:58 +0100
Message-ID: <a5d9929e0907070824o5cc31256jd2d1391b31c29702@mail.gmail.com>
Subject: [PATCH 0/3] Increase lockdep limits
To: LKML <linux-kernel@vger.kernel.org>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

These patches apply on top of Linus current tree (as of 2.6.31-rc2).

They increase the limits on lockdep usage that have been reported as
being hit repeatedly, and in most (all?) those reported cases, as
false positives. Increasing those values will allow for lockdep to
work as intended, rather than being turned off too early.

They can be applied separately, but if you apply them in order, you
increase all the limits reported as false positive so far, and in the
order in which they are hit.

As to the actual changes, its only value-by-value changes, no logic changes.

It has the It-works-for-me stamp.

include/linux/sched.h |    2 +-
 kernel/lockdep_internals.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

(First patches i submit, please hold on the pitchforks and flaming tar)

Thank you very much for your time,
Joao Correia
