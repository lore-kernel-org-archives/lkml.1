Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYAOW1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYAOW1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbYAOW1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:27:12 -0500
Received: from 247.sub-75-209-114.myvzw.com ([75.209.114.247]:38359 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752929AbYAOW1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:27:11 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 17:27:11 EST
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 4] x86: some more patches
Message-Id: <patchbomb.1200435425@localhost>
Date: Tue, 15 Jan 2008 14:17:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

More patches:

- rearrange paravirt.h to remove duplicate code, and to make it easy
  to drop in 4th level pagetable functions.
- fix a warning I got from clear_bit in pgtable.h
- fix up some bogosity in pte_modify
- mask NX from pte_pfn

The last two may help with the problem that Andi's seeing.

Thanks,
	J


