Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbZC2UV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbZC2UV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZC2UVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:21:16 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60783 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZC2UVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=dckt3zeelhhd+PsjbUy4CU9swE7HaZRnL+o8HfpZAfg82YzSQB01dhIh7kT7/ayIhQ
         ukA0w2oTyAAaVtx0Zgcheao5iDseNGf6bxpgWbKJwgZA/luJ/MJ9dBu8i5uaez6SrMn5
         HJ8uhronN2Vv+hFjyyh80Wc+lsUF/S4euUDLQ=
Message-Id: <20090329201545.470255691@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 30 Mar 2009 00:15:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com
Subject: [patch 0/6] x86-tip: merge irqinit_32/64.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is an attempt to merge irqinit_32/64 with minimum
changes by small steps.

Please review. Need serious testing and actually have
two problems in which I need help:

1) #include's verification and cleanup
2) APIC MCE assignments seems to be a bit
   not clear in general -- at moment I added
   preprocessor directives to not change current
   behaviour but in real there should be a review
   to check if we don't set vectors without handlers.
   Maybe I'm just screwed up -- too tired will check tomorrow :)

The patches are on top of -tip

|
| commit 71f60f2853b4ba53da35f51bc3e64ec6ad92ea90
| Merge: 305f38e f5b3ca6
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Sat Mar 28 13:13:08 2009 +0100
|
|    Merge branch 'x86/mce2'

Any comments are quite welcome. Thanks!

Cyrill
