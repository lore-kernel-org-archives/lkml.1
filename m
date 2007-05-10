Return-Path: <linux-kernel-owner+w=401wt.eu-S1763292AbXEKTLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763292AbXEKTLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763076AbXEKTJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:09:55 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:60104 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763053AbXEKTJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:09:54 -0400
Message-Id: <20070510235708.155502000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 16:57:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 0/7] A series of cleanup patches
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, Andrew:

Here's a little set of cleanup patches.  They're general cleanups,
but also the final prerequisites for the Xen series.

They are:
 - move pieces of i386 SMP into a common file, so they can be used by
   other sub-arches and Xen
 - Make vsyscall (and vdso) use the common linux/elfnote.h macros
 - Add kstrndup
 - Add argv_split
 - Cleanup and generalize the call_usermodehelper APIs
 - Add a common orderly poweroff function
 - And some more usermodehelper cleanups, to change the "wait" arg from
   a semi-cryptic int into a less cryptic enum.

Thanks,
	J

-- 

