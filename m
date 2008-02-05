Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYBEGep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYBEGep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYBEGei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:34:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41213 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYBEGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:34:37 -0500
Date: Mon, 4 Feb 2008 22:34:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Igor M Podlesny <for.poige+linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: NVIDIA's Linux x86 Display Driver fresh driver isn't compatible
 anymore
Message-ID: <20080204223430.415161e9@laptopd505.fenrus.org>
In-Reply-To: <47A80218.3040304@gmail.com>
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>
	<20080202235103.20dd9768.akpm@linux-foundation.org>
	<47A71040.5000300@gmail.com>
	<20080204052709.12f4e0d3.akpm@linux-foundation.org>
	<47A7F4DB.3070406@gmail.com>
	<47A80218.3040304@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 13:28:40 +0700
Igor M Podlesny <for.poige+linux@gmail.com> wrote:

> On 2008-02-05 12:32, Igor M Podlesny wrote:
> > On 2008-02-04 20:27, Andrew Morton wrote:
> >> On Mon, 04 Feb 2008 20:16:48 +0700 Igor M Podlesny
> >> <for.poige+linux@gmail.com> wrote:
> > [...]
> >>>    Now I can say that both 2.6.24-mm1 and 2.6.24-git11 do NOT
> >>> "see" any of mine LVM-2 disks. pvscan, for e.g., finds nothing at
> >>> all.
> >> 
> >> You may find that you need to update your lvm userspace tools.
> > 
> > 	You're right; I've updated my initrd with fresh lvm
> > userspace-counterpart and now the problem has been fixed. Sorry for
> > groundless alert.
> > 
> > 	Thanks!
> 
> 	But as russian proverb says, trouble never comes alone. :-)
> NVIDIA's fresh driver isn't compatible anymore:
> 
> 	1) To have compiled it I had to replace global_flush_tlb()
> call with __flush_tlb_all() and still guessing was it(?) a correct
> replacment at all :-)

it is not; 
> 
> 	2) When loading it emits such messages:
> 
> 		nvidia: Unknown symbol change_page_attr
> 		nvidia: Unknown symbol init_mm
> 
> 	Can it be quick and easy solved?

best asked at one of the nvidia forums, not on lkml...
they need to adjust a few API calls, it's not hard work but they need
to do that (their driver isn't open source)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
