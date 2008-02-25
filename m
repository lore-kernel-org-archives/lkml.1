Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYBYOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYBYOuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYBYOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:49:59 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:32867 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754646AbYBYOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:49:58 -0500
To: linux-kernel@vger.kernel.org
Subject: Should a x86 gdb work under an x86_64 kernel?
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1JTeeF-0005dk-Nv@closure.thunk.org>
Date: Mon, 25 Feb 2008 09:49:43 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	I've noticed that if I try to use a 32-bit x86 gdb to debug a
32-bit program under a 64-bit x86_64 kernel, gdb (version 6.6-debian,
from Ubuntu Gutsy) immediately core dumps as soon as I run the test
program under the debugger.  Is this normal/expected/known bug?

	I haven't tried bisecting it yet, but it's been broken as early
as a little after 2.6.25-rc1, in late January.  But before I spend a
large amount of time doing the bisect, I thought I'd ask if anyone has
heard of this issue.  Does this sound familiar?

						- Ted
