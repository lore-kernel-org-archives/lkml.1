Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbZEZXS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbZEZXS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbZEZXSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53151 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991AbZEZXSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:30 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Subject: x86 Machine check 32bit merge series
Date: Wed, 27 May 2009 01:17:59 +0200
Message-Id: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Machine checks are CPU errors which can be handled by the OS.

Here's an updated x86 machine check 32bit<->64bit merge series. It allows
to use the much superior (ok I am biased...) 64bit machine check code
on 32bit systems too.

It also contains the basic machine check injector code because 
that was needed for testing.

I had this in the original mce patchkit, but dropped it later, but maintainers
requested to redo it.

This was available for some time on my git tree on kernel.org, but
I'm reposting it now for final merge.

This is based on the mce3 branch in
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git
which is a version of x86/mce2 branch from tip that actually compiles/works and
is rebased on 2.6.30rc7.

This is all ready to merge.

Merging would be:

Pull in mce3
Apply this patch series on top of it
(or pull it from
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce3-32bitmerge
)
then apply the following mce improvements series or
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce3-improvements

-Andi



