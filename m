Return-Path: <linux-kernel-owner+w=401wt.eu-S932391AbYBBJCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbYBBJCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbYBBJBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:01:32 -0500
Received: from gw.goop.org ([64.81.55.164]:59429 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772AbYBBJBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:01:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 5] x86: add alloc/release_pud; more demacroing
Message-Id: <patchbomb.1201908323@localhost>
Date: Fri, 01 Feb 2008 15:25:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Zach Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series:
 1. Renames the alloc/release_{pt,pd} calls to _pte, _pmd so that its
    clear what they operate on.
 2. Adds alloc/release_pud, and puts calls in the appropriate places
 3. Demacros some stuff in pgtable.h

A bit eclectic, but all fairly straightforward (and no changes to
non-x86 headers ;).

Thanks,
	J


