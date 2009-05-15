Return-Path: <linux-kernel-owner+w=401wt.eu-S1763028AbZEOMRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028AbZEOMRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762267AbZEOMNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:13:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43959 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762213AbZEOMNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:13:33 -0400
Date: Fri, 15 May 2009 14:19:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Josef Bacik <josef@redhat.com>,
       sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
Message-ID: <20090515121905.GE16682@one.firstfloor.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com> <87k54iq2gv.fsf@basil.nowhere.org> <871vqqkdf0.wl%vmayatsk@redhat.com> <20090515093838.GB16682@one.firstfloor.org> <87hbzmd1g6.wl%vmayatsk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbzmd1g6.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, "shall attempt"... It's not clear to me, is it enough just to
> validate user's buffer and gave up with error, like we do now?

I think it is.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
