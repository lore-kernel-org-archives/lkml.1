Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYCRF34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYCRF34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYCRFYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:24 -0400
Received: from gw.goop.org ([64.81.55.164]:37849 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbYCRFYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 31] x86: unification and xen updates
Message-Id: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:36:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This is a great big pile of x86 unification and Xen bugfix patches.
They build and boot for me on 64-bit and 32-bit (PAE and non-PAE).

Patches are based on x86.git#testing as of this morning.

The overview:

 - a couple of Xen bugfixes, which are 2.6.24 and 2.6.25 material
 - a bunch of x86 cleanups and unifications, mostly around pgalloc
 - some Xen fixes and improvements:
   - unify PAE/non-PAE pagetable handling
   - implement sysenter where applicable

Thanks,
	J


