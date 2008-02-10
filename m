Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYBJV0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYBJV0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYBJV0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:26:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51598 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYBJV0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:26:10 -0500
Date: Sun, 10 Feb 2008 13:26:05 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Adam Litke <agl@us.ibm.com>, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: 2.6.24-git20 -- BUG: sleeping function called from invalid
	context at include/asm/uaccess_32.h:449
Message-ID: <20080210212605.GB17442@us.ibm.com>
References: <a44ae5cd0802091103s4c24c70fyc747d9c4ab9a9897@mail.gmail.com> <20080209162643.fd3822f1.akpm@linux-foundation.org> <20080209163812.704cf282@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209163812.704cf282@laptopd505.fenrus.org>
X-Operating-System: Linux 2.6.24-g8561b089 (x86_64)
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.02.2008 [16:38:12 -0800], Arjan van de Ven wrote:
> On Sat, 9 Feb 2008 16:26:43 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Ugh, how did I let that one through?
> > 
> > Guys, how often mut it be said?  PLEASE always test all code with all
> > kernel deubg options enabled.
> 
> maybe we should make a CONFIG_KERNEL_DEVELOPER option that SELECTs the
> various options that really should be on.
> 
> If there is a chance of reasonable agreement on what those options are
> I'll cook up a patch... (but I don't want to get bogged down in a 500
> mail flamewar about CONFIG_FOO_BAR being right for this or not...)

I would support such a CONFIG_ option. But in this case, it was plain
oversight / poor engineering on my part. So, while it may have helped,
doesn't make up for deficiencies on my end.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
