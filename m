Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbYKJOUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbYKJOUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYKJOUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:20:43 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34225 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753915AbYKJOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:20:42 -0500
Subject: Re: [PATCH] fix smp generic helper voyager breakage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <Jens.Axboe@oracle.com>
In-Reply-To: <20081110093516.GK22392@elte.hu>
References: <1225400980.19324.24.camel@localhost.localdomain>
	 <20081030215421.GG30303@elte.hu>
	 <1225404368.19324.49.camel@localhost.localdomain>
	 <20081030222111.GA18600@elte.hu>
	 <1226253194.19841.9.camel@localhost.localdomain>
	 <20081110093516.GK22392@elte.hu>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 08:20:32 -0600
Message-Id: <1226326832.5014.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 10:35 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date: Wed, 29 Oct 2008 14:53:06 -0500
> > Subject: [VOYAGER] fix generic smp helpers non compile
> 
> hm, i reported a bug to you with this patch on Oct 30.
> 
> > commit 3d4422332711ef48ef0f132f1fcbfcbd56c7f3d1
> > Author: Jens Axboe <jens.axboe@oracle.com>
> > Date:   Thu Jun 26 11:21:34 2008 +0200
> > 
> >     Add generic helpers for arch IPI function calls
> > 
> > didn't wire up the voyager smp call function correctly, so do that
> > here.  Also make CONFIG_USE_GENERIC_SMP_HELPERS a def_bool y again,
> > since we now use the generic helpers for every x86 architecture.
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  arch/x86/Kconfig                    |    5 ++++-
> >  arch/x86/mach-voyager/voyager_smp.c |   16 ++++++++++++++--
> >  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> no indication in the changelog whether that bug i reported got fixed - 
> did it? (i suspect it did, but not sure)

Yes ... that would be why this was a reply to the discussion email with
the report.

James


