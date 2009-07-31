Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZGaUah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZGaUah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 16:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZGaUah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 16:30:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbZGaUag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 16:30:36 -0400
Date: Fri, 31 Jul 2009 13:29:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Richter <robert.richter@amd.com>
Cc: jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: oprofile/op_model_amd.c set return values for
 op_amd_handle_ibs()
Message-Id: <20090731132927.88c400cc.akpm@linux-foundation.org>
In-Reply-To: <20090618144731.GX18016@erda.amd.com>
References: <1245325167.7189.9.camel@localhost.localdomain>
	<20090618144731.GX18016@erda.amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 16:47:31 +0200
Robert Richter <robert.richter@amd.com> wrote:

> On 18.06.09 17:09:27, Jaswinder Singh Rajput wrote:
> > 
> > op_amd_handle_ibs() should return 0 when IBS is not present or not defined.
> > 
> > Fix compilation warning:
> >  CC [M]  arch/x86/oprofile/op_model_amd.o
> >  arch/x86/oprofile/op_model_amd.c: In function ___op_amd_handle_ibs___:
> >  arch/x86/oprofile/op_model_amd.c:217: warning: no return statement in function returning non-void
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/oprofile/op_model_amd.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> Applied to:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git master
> 

Something has gone badly wrong.  This patch took six weeks to turn up
in linux-next.

Apart from anything else this led me to have to fix something which was
already fixed.

All you guys *saw* that fix and still this didn't prompt anyone to
wonder what had gone wrong.

My fix is better, too.  The op_amd_handle_ibs() return value is
ignored, so it should return void.

