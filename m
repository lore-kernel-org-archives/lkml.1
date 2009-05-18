Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZERKK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZERKK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbZERKKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:10:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44009 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbZERKKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:10:30 -0400
Date: Mon, 18 May 2009 12:16:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
Message-ID: <20090518101614.GM16682@one.firstfloor.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com> <87k54iq2gv.fsf@basil.nowhere.org> <871vqqkdf0.wl%vmayatsk@redhat.com> <20090515093838.GB16682@one.firstfloor.org> <20090515134315.GB8235@shareable.org> <20090518093136.152a1bb7@lxorguk.ukuu.org.uk> <20090518094808.GA12041@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518094808.GA12041@shareable.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is EFAULT really optional on systems with page protection?

It's de facto -- e.g. the x86-64 vsyscalls (getimeofday, time, clock_gettime,
getcpu) never implement it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
