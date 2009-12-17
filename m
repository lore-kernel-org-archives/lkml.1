Return-Path: <linux-kernel-owner+w=401wt.eu-S965195AbZLQPia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965195AbZLQPia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965186AbZLQPi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:38:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965183AbZLQPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:38:26 -0500
Date: Thu, 17 Dec 2009 07:37:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
In-Reply-To: <200912171618.32882.bzolnier@gmail.com>
Message-ID: <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com> <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain> <200912171618.32882.bzolnier@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> Examples? :)

They're typically things like this:

-			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
+			ret = sscanf(buf, "0x%lx - 0x%lx", &start_addr,
+				&end_addr);

ie a line-break that is just annoying and makes the code harder to read 
rather than easier. 

			Linus
