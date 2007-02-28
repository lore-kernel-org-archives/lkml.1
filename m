Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbXB1IXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbXB1IXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbXB1IXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:23:36 -0500
Received: from fb2.tech.numericable.fr ([82.216.111.50]:46670 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbXB1IXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:23:36 -0500
X-Greylist: delayed 1435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 03:23:35 EST
From: Damien Wyart <damien.wyart@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
Date: Wed, 28 Feb 2007 08:59:37 +0100
In-Reply-To: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	(Linus Torvalds's message of "Tue\, 27 Feb 2007 21\:16\:28 -0800 \(PST\)")
Message-ID: <87k5y24sra.fsf@brouette.noos.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.94
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [070228 06:16]:
> Anyway, I really hope the thing starts calming down now, and everybody
> should take a hard look at the regressions lists that Adrian has
> started sending out. We already fixed some of them, but there is more
> to go..

Ingo's patch correcting a bug in the SMT scheduler
(http://lkml.org/lkml/2007/2/26/103) seems to have been missed. It is
quite important when using dynticks.

-- 
Damien Wyart
