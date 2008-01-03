Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYADFlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYADFlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYADFjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:37 -0500
Received: from gw.goop.org ([64.81.55.164]:48780 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYADFjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:35 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 8] x86: unify asm/page.h
Message-Id: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:10:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a series which concentrates on unifying and cleaning up
asm-86/page*.h.  Each patch in the series restricts itself to doing
one thing fairly simply, so it should be fairly low-risk and easy to
bisect.

The early version of this patch got rid of asm/page_32|64.h entirely,
but I decided the resulting #ifdef hell was too hard to deal with, so
I moved purely 32/64-bit specific stuff into their own files.

Thanks,
	J


