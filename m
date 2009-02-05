Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZBETcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZBETcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZBETcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:18 -0500
Received: from gw.goop.org ([64.81.55.164]:40039 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbZBETcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:17 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 36] x86: clean up pte functions in pgtable*.h
Message-Id: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a bunch of tiny patches to move as much as possible from
pgtable_*.h to pgtable.h.  This serves two purposes:

 1. There was a lot of redundancy in there, so there's a fair amount
    of unification, and

 2. Moves all the pte-manipulation into one place, to make further
    header restructuring easier.

Lightly built on 32 and 64-bit pvops, and 64-bit non-pvops configs.
64-bit test boot under kvm.

Thanks,
	J

