Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbZLOKrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbZLOKrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZLOKrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:47:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37114 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZLOKrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:47:16 -0500
Date: Tue, 15 Dec 2009 11:47:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Emese Revfy <re.emese@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
 2.6.32-git-053fe57ac v2
Message-ID: <20091215104706.GG17930@elf.ucw.cz>
References: <cover.1260662994.git.re.emese@gmail.com>
 <20091214003836.GD7812@parisc-linux.org>
 <4B2595E7.701@gmail.com>
 <20091214021916.GB12196@linux-sh.org>
 <4B25E47C.1010803@gmail.com>
 <20091214112656.GB1959@elf.ucw.cz>
 <20091214080049.19930729@infradead.org>
 <4B26C68D.1080300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B26C68D.1080300@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-12-15 00:13:17, Emese Revfy wrote:
> Arjan van de Ven wrote:
> > Now, a 300 patch series to lkml is not the way to do this.
> > First step is to make checkpatch.pl warn about new cases.
> 
> I will add this structures the checkpatch in the next patch series.
> 
> > Second step should be to convert all definitions, but using the "one
> > patch per maintainer" rule, not "one patch per file" rule. Yes it's
> > somewhat janitorial, but no it's not a big deal as long as it's not 300
> > patches to lkml. And it is much better than whitespace changes; it's
> > a real quality improvement to the kernel (in terms of code generation
> > and API)
> 
> The first series was based on one patch per structure type, the current
> split-up is based on one patch per structure type *and* subsystem as
> suggested by Greg KH. I used get_maintainer --subsystem to find them which
> resulted in 150 patches. If you know a better way or want per-type patches,
> please let me know (and discuss it with Greg ;).

Please push VFS patches first -- in small series. Unless you can
address Al Viro's objections, I do not think rest should go in (and no
need to spam l-k in the process).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
