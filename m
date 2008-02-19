Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYBSTPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYBSTPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYBSTOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:14:53 -0500
Received: from mx28.mail.ru ([194.67.23.67]:18254 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbYBSTOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:14:52 -0500
Date: Tue, 19 Feb 2008 22:16:21 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ufs: [bl]e*_add_cpu conversion
Message-ID: <20080219191621.GA10986@rain>
Mail-Followup-To: Marcin Slusarz <marcin.slusarz@gmail.com>,
	Roel Kluin <12o3l@tiscali.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com> <47B2BB58.5040401@tiscali.nl> <20080215212815.26117a19.akpm@linux-foundation.org> <47BA132B.4050005@tiscali.nl> <20080219174524.GA6096@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219174524.GA6096@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 06:45:42PM +0100, Marcin Slusarz wrote:
> On Tue, Feb 19, 2008 at 12:22:19AM +0100, Roel Kluin wrote:
> > Andrew Morton wrote:
> > > On Wed, 13 Feb 2008 10:41:44 +0100 Roel Kluin <12o3l@tiscali.nl> wrote:
> > > 
> > >> you may also want these:
> > >> ---
> > >> [bl]e_add_cpu conversion in return
> > 
> > > upsets powerpc (at least):
> > > 
> > > fs/ufs/swab.h: In function `fs64_add':
> > > fs/ufs/swab.h:47: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
> > > fs/ufs/swab.h:49: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
> > > fs/ufs/swab.h: In function `fs64_sub':
> > > fs/ufs/swab.h:58: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
> > > fs/ufs/swab.h:60: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
> > 
> > sorry for this. Is it correct to cast like the patch below does?
> I don't think so. Their prototypes are wrong. We can:
> a) remove fs64_add and fs64_sub as nobody use them
> b) fix them - change second parameter do __fs64 (and convert to [bl]e64_add_cpu)
> 
> Evgeniy?
> 

I vote for removing unused code.

-- 
/Evgeniy

