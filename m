Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYJIXx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYJIXx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYJIXxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:53:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:49152 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYJIXxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FerMfuwEeaAyq1UWBN2iDLlGXLWE//W/F1W6VPrTq1mbNt2n4YPk7gEFQALPE/uvqj
         esfijGaDep3mLX2KuZQGX4cNDEzBiHerzaDA7Nuh7w3E1rVCR+drO35/DiUs6bEerDaw
         6IRjAGlnG2O2Y4XGMzU+/i8FPu4zldurBzWEc=
Subject: Re: [patch] clean hex output of ftrace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>
In-Reply-To: <20081009123113.GB2952@elte.hu>
References: <Pine.LNX.4.30.0810081715520.2487-100000@perches.com>
	 <1223513095.8195.113.camel@brick>  <20081009123113.GB2952@elte.hu>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 16:53:46 -0700
Message-Id: <1223596426.17735.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 14:31 +0200, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > On Wed, 2008-10-08 at 17:16 -0700, Joe Perches wrote:
> > > On Wed, 8 Oct 2008, Harvey Harrison wrote:
> > > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > > Subject: [PATCH] ftrace: Fix inversion of hex output and use common routines
> > > 
> > > You're quick...
> > > 
> > > >  	BUG_ON(len >= HEX_CHARS);
> > > 
> > > I think the BUG_ON is senseless.
> > > 
> > 
> > Agreed, it probably meant to say BUG_ON(len * 2 > HEX_CHARS -1)
> > 
> > But as this is only called from within a helper macro, it could be
> > changed to a build-time check instead of a runtime:
> > 
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > Subject: [PATCH] trace: add build-time check to avoid overrunning hex buffer
> 
> applied to tip/tracing/core:
> 
>  bb86ba7: trace: add build-time check to avoid overrunning hex buffer
>  32ce86f: ftrace: fix hex output mode of ftrace
> 

Thinking about this, these should probably be forwarded to -stable once
they go into mainline.

Cheers,

Harvey

