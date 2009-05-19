Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZESI5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZESI5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZESI4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:56:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40392 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZESI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:56:55 -0400
Date: Tue, 19 May 2009 10:55:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by
	check_readable_bytes()
Message-ID: <20090519085538.GC1366@ucw.cz>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch changes iov_iter_fault_in_readable() to use check_readable_bytes()
> instead of fault_in_pages_readable(). It allows iov_iter_fault_in_readable()
> callers to know how much data is accessible and proceed with it. It makes
> sys_write() more POSIX-friendly.

I agree with andi here: yes, your suggested behaviour is 'nicer', but
I don't the code complexity is worth it.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
