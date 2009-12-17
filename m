Return-Path: <linux-kernel-owner+w=401wt.eu-S936296AbZLQPPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936296AbZLQPPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936193AbZLQPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:15:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935919AbZLQPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:15:08 -0500
Date: Thu, 17 Dec 2009 07:14:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
In-Reply-To: <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>  <200912152326.34728.bzolnier@gmail.com> <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Américo Wang wrote:
> 
> I like this patch, this is actually what I wanted to do.

I have nothing against a switch, but it had better default to off.

The whole 80-char limit is insane. It results in insane "fixes". Just 
about every time somebody "improves" a patch due to the warning, the 
result is worse than the original patch.

		Linus
