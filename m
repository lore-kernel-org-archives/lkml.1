Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZEON4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZEON4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZEON4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:56:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZEON4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:56:05 -0400
Date: Fri, 15 May 2009 16:01:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
Message-ID: <20090515140137.GF16682@one.firstfloor.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com> <87k54iq2gv.fsf@basil.nowhere.org> <871vqqkdf0.wl%vmayatsk@redhat.com> <20090515093838.GB16682@one.firstfloor.org> <20090515134315.GB8235@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515134315.GB8235@shareable.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be quite nice if it were safe to call read(), get EFAULT

Even with that patch it is not safe, not even for write, because
it's racy.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
