Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbYAZF2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbYAZF2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYAZF2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:28:03 -0500
Received: from [212.12.190.175] ([212.12.190.175]:60668 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751062AbYAZF17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:27:59 -0500
From: Al Boldi <a1426z@gawab.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Sat, 26 Jan 2008 08:27:50 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <15182.1201211935@turing-police.cc.vt.edu>
In-Reply-To: <15182.1201211935@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801260827.50930.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 24 Jan 2008 23:36:00 +0300, Al Boldi said:
> > This RFC proposes to introduce a tunable which allows to disable fsync
> > and changes ordered into writeback writeout on a per-process basis like
> > this:
:
:
> But if you want to give them enough rope to shoot themselves in the foot
> with, I'd suggest abusing LD_PRELOAD to replace the fsync() glibc code
> instead.  No need to clutter the kernel with rope that can be (and has
> been) done in userspace.

Ok that's possible, but as you cannot use LD_PRELOAD to deal with changing 
ordered into writeback mode, we might as well allow them to disable fsync 
here, because it is in the same use-case.


Thanks!

--
Al

